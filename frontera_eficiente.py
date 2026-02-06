"""
Frontera Eficiente de Markowitz
===============================
Descarga las 10 acciones mas rentables del S&P 500 del ultimo anio desde
Yahoo Finance y construye la frontera eficiente usando simulacion de
Monte Carlo y optimizacion numerica.

Uso:
    python3 frontera_eficiente.py

Si no hay conexion a Yahoo Finance, se usan datos de muestra realistas
para demostrar el modelo.
"""

import datetime as dt
import warnings

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy.optimize import minimize

warnings.filterwarnings("ignore")

# ---------------------------------------------------------------------------
# Configuracion
# ---------------------------------------------------------------------------
CANDIDATOS = [
    "AAPL", "MSFT", "NVDA", "AMZN", "META", "GOOGL", "TSLA", "AVGO",
    "JPM", "V", "UNH", "LLY", "MA", "HD", "PG", "XOM", "COST", "JNJ",
    "ABBV", "CRM", "MRK", "NFLX", "AMD", "PEP", "KO", "ADBE", "TMO",
    "WMT", "CSCO", "ORCL", "ACN", "MCD", "ABT", "DHR", "TXN", "INTC",
    "PM", "NEE", "MS", "GS",
]

NUM_TOP = 10
NUM_PORTFOLIOS = 50_000
DIAS_TRADING = 252
TASA_LIBRE = 0.04


# ---------------------------------------------------------------------------
# Descarga de datos
# ---------------------------------------------------------------------------
def descargar_precios(tickers: list[str], inicio: str, fin: str) -> pd.DataFrame:
    """Descarga precios de cierre ajustados desde Yahoo Finance."""
    import yfinance as yf

    print(f"Descargando datos de {len(tickers)} acciones desde Yahoo Finance...")
    datos = yf.download(tickers, start=inicio, end=fin, auto_adjust=True, progress=False)

    if isinstance(datos.columns, pd.MultiIndex):
        precios = datos["Close"]
    else:
        precios = datos[["Close"]]

    precios = precios.dropna(axis=1, how="all").dropna()

    if precios.empty or precios.shape[1] < NUM_TOP:
        raise ConnectionError("No se obtuvieron suficientes datos de Yahoo Finance")

    return precios


def generar_datos_muestra() -> pd.DataFrame:
    """
    Genera precios sinteticos realistas basados en retornos historicos tipicos
    de las principales acciones del S&P 500 (para demostracion offline).
    """
    print("Usando datos de muestra realistas (sin conexion a Yahoo Finance)...")

    np.random.seed(42)
    n_dias = DIAS_TRADING

    # Retornos anualizados y volatilidades tipicas (basados en datos reales 2024-2025)
    acciones = {
        "NVDA":  {"ret": 1.80, "vol": 0.55},
        "META":  {"ret": 0.75, "vol": 0.38},
        "AVGO":  {"ret": 0.90, "vol": 0.42},
        "NFLX":  {"ret": 0.65, "vol": 0.35},
        "AMZN":  {"ret": 0.50, "vol": 0.32},
        "GOOGL": {"ret": 0.40, "vol": 0.28},
        "AAPL":  {"ret": 0.30, "vol": 0.24},
        "MSFT":  {"ret": 0.25, "vol": 0.25},
        "LLY":   {"ret": 0.60, "vol": 0.30},
        "GS":    {"ret": 0.55, "vol": 0.28},
        "TSLA":  {"ret": 0.20, "vol": 0.60},
        "JPM":   {"ret": 0.35, "vol": 0.22},
        "CRM":   {"ret": 0.30, "vol": 0.33},
        "AMD":   {"ret": 0.15, "vol": 0.50},
        "XOM":   {"ret": 0.10, "vol": 0.25},
    }

    # Matriz de correlacion simplificada (tech correlacionadas entre si)
    tickers = list(acciones.keys())
    n = len(tickers)

    # Construir precios con caminata aleatoria correlacionada
    base_corr = 0.3
    tech_tickers = {"NVDA", "META", "AVGO", "AMZN", "GOOGL", "AAPL", "MSFT", "NFLX", "AMD", "CRM", "TSLA"}

    corr = np.eye(n)
    for i in range(n):
        for j in range(i + 1, n):
            ti, tj = tickers[i], tickers[j]
            if ti in tech_tickers and tj in tech_tickers:
                corr[i, j] = corr[j, i] = 0.55 + np.random.uniform(-0.1, 0.1)
            else:
                corr[i, j] = corr[j, i] = base_corr + np.random.uniform(-0.1, 0.1)

    # Cholesky para generar retornos correlacionados
    L = np.linalg.cholesky(corr)
    vols_diarios = np.array([acciones[t]["vol"] / np.sqrt(DIAS_TRADING) for t in tickers])
    mus_diarios = np.array([acciones[t]["ret"] / DIAS_TRADING for t in tickers])

    Z = np.random.randn(n_dias, n)
    retornos_corr = Z @ L.T * vols_diarios + mus_diarios

    # Convertir a precios
    precios_base = np.array([100 + np.random.uniform(-20, 80) for _ in tickers])
    precios_mat = np.zeros((n_dias + 1, n))
    precios_mat[0] = precios_base

    for t_idx in range(n_dias):
        precios_mat[t_idx + 1] = precios_mat[t_idx] * (1 + retornos_corr[t_idx])

    fechas = pd.bdate_range(end=dt.datetime.now(), periods=n_dias + 1)
    df = pd.DataFrame(precios_mat, index=fechas, columns=tickers)

    return df


# ---------------------------------------------------------------------------
# Funciones de analisis
# ---------------------------------------------------------------------------
def seleccionar_top_rentables(precios: pd.DataFrame, n: int) -> list[str]:
    """Selecciona las n acciones con mayor retorno acumulado."""
    retorno_acumulado = (precios.iloc[-1] / precios.iloc[0] - 1).sort_values(ascending=False)
    top = retorno_acumulado.head(n)
    print(f"\n{'='*55}")
    print(f"  Top {n} acciones mas rentables (retorno ultimo anio)")
    print(f"{'='*55}")
    for ticker, ret in top.items():
        print(f"  {ticker:6s}  {ret:+.2%}")
    return top.index.tolist()


def calcular_metricas(precios: pd.DataFrame):
    """Calcula retornos diarios, retorno esperado anualizado y covarianza."""
    retornos = precios.pct_change().dropna()
    mu = retornos.mean() * DIAS_TRADING
    cov = retornos.cov() * DIAS_TRADING
    return retornos, mu, cov


def simular_portfolios(mu: pd.Series, cov: pd.DataFrame, n_port: int):
    """Genera n_port portfolios aleatorios y calcula retorno/riesgo/Sharpe."""
    n_activos = len(mu)
    resultados = np.zeros((3, n_port))
    pesos_todos = np.zeros((n_port, n_activos))

    for i in range(n_port):
        w = np.random.random(n_activos)
        w /= w.sum()
        pesos_todos[i] = w

        ret_p = np.dot(w, mu)
        vol_p = np.sqrt(np.dot(w.T, np.dot(cov.values, w)))
        sharpe = (ret_p - TASA_LIBRE) / vol_p

        resultados[0, i] = vol_p
        resultados[1, i] = ret_p
        resultados[2, i] = sharpe

    return resultados, pesos_todos


def optimizar_sharpe(mu: pd.Series, cov: pd.DataFrame):
    """Encuentra el portfolio de maximo Sharpe Ratio."""
    n = len(mu)

    def neg_sharpe(w):
        ret_p = np.dot(w, mu)
        vol_p = np.sqrt(np.dot(w.T, np.dot(cov.values, w)))
        return -(ret_p - TASA_LIBRE) / vol_p

    restricciones = {"type": "eq", "fun": lambda w: np.sum(w) - 1}
    limites = tuple((0, 1) for _ in range(n))
    w0 = np.ones(n) / n

    opt = minimize(neg_sharpe, w0, method="SLSQP", bounds=limites, constraints=restricciones)
    return opt.x


def optimizar_min_varianza(cov: pd.DataFrame):
    """Encuentra el portfolio de minima varianza."""
    n = cov.shape[0]

    def varianza(w):
        return np.dot(w.T, np.dot(cov.values, w))

    restricciones = {"type": "eq", "fun": lambda w: np.sum(w) - 1}
    limites = tuple((0, 1) for _ in range(n))
    w0 = np.ones(n) / n

    opt = minimize(varianza, w0, method="SLSQP", bounds=limites, constraints=restricciones)
    return opt.x


def graficar_frontera(resultados, mu, cov, tickers):
    """Genera el grafico de la frontera eficiente."""
    w_sharpe = optimizar_sharpe(mu, cov)
    ret_sharpe = np.dot(w_sharpe, mu)
    vol_sharpe = np.sqrt(np.dot(w_sharpe.T, np.dot(cov.values, w_sharpe)))

    w_minvar = optimizar_min_varianza(cov)
    ret_minvar = np.dot(w_minvar, mu)
    vol_minvar = np.sqrt(np.dot(w_minvar.T, np.dot(cov.values, w_minvar)))

    fig, ax = plt.subplots(figsize=(12, 7))

    # Nube de portfolios simulados
    scatter = ax.scatter(
        resultados[0], resultados[1],
        c=resultados[2], cmap="viridis", marker="o", s=5, alpha=0.5,
    )
    plt.colorbar(scatter, ax=ax, label="Sharpe Ratio")

    # Portfolio maximo Sharpe
    ax.scatter(
        vol_sharpe, ret_sharpe, marker="*", color="red", s=300, zorder=5,
        label=f"Max Sharpe (ret={ret_sharpe:.2%}, vol={vol_sharpe:.2%})",
    )

    # Portfolio minima varianza
    ax.scatter(
        vol_minvar, ret_minvar, marker="D", color="blue", s=150, zorder=5,
        label=f"Min Varianza (ret={ret_minvar:.2%}, vol={vol_minvar:.2%})",
    )

    # Capital Market Line (CML)
    x_cml = np.linspace(0, resultados[0].max(), 100)
    sharpe_opt = (ret_sharpe - TASA_LIBRE) / vol_sharpe
    y_cml = TASA_LIBRE + sharpe_opt * x_cml
    ax.plot(x_cml, y_cml, "r--", linewidth=1, alpha=0.7, label="CML")

    # Activos individuales
    for i, t in enumerate(tickers):
        vol_i = np.sqrt(cov.values[i, i])
        ret_i = mu.values[i]
        ax.scatter(vol_i, ret_i, marker="x", color="black", s=80, zorder=5)
        ax.annotate(t, (vol_i, ret_i), fontsize=8, xytext=(5, 5),
                    textcoords="offset points")

    ax.set_xlabel("Volatilidad (riesgo anualizado)", fontsize=12)
    ax.set_ylabel("Retorno esperado anualizado", fontsize=12)
    ax.set_title("Frontera Eficiente de Markowitz - Top 10 acciones", fontsize=14)
    ax.legend(fontsize=9, loc="upper left")
    ax.grid(True, alpha=0.3)

    fig.tight_layout()
    fig.savefig("frontera_eficiente.png", dpi=150)
    print("\nGrafico guardado en: frontera_eficiente.png")

    return w_sharpe, w_minvar


def imprimir_asignacion(titulo: str, pesos, tickers, mu, cov):
    """Imprime la composicion de un portfolio."""
    print(f"\n{'='*50}")
    print(f"  {titulo}")
    print(f"{'='*50}")
    for t, w in sorted(zip(tickers, pesos), key=lambda x: -x[1]):
        if w > 0.001:
            print(f"  {t:6s}  {w:7.2%}")

    ret = np.dot(pesos, mu)
    vol = np.sqrt(np.dot(pesos.T, np.dot(cov.values, pesos)))
    sharpe = (ret - TASA_LIBRE) / vol
    print(f"  {'---':6s}  {'-------':>7s}")
    print(f"  Retorno esperado:  {ret:.2%}")
    print(f"  Volatilidad:       {vol:.2%}")
    print(f"  Sharpe Ratio:      {sharpe:.2f}")


# ---------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    periodo_inicio = (dt.datetime.now() - dt.timedelta(days=365)).strftime("%Y-%m-%d")
    periodo_fin = dt.datetime.now().strftime("%Y-%m-%d")
    usando_muestra = False

    # 1. Intentar descargar de Yahoo Finance; si falla, usar datos de muestra
    try:
        precios_todos = descargar_precios(CANDIDATOS, periodo_inicio, periodo_fin)
    except Exception as e:
        print(f"  Error de conexion: {e}")
        precios_todos = generar_datos_muestra()
        usando_muestra = True

    # 2. Seleccionar top 10
    top_tickers = seleccionar_top_rentables(precios_todos, NUM_TOP)

    # 3. Precios solo del top 10
    precios_top = precios_todos[top_tickers]

    # 4. Metricas
    retornos, mu, cov = calcular_metricas(precios_top)

    # 5. Simulacion Monte Carlo
    print(f"\nSimulando {NUM_PORTFOLIOS:,} portfolios aleatorios...")
    resultados, pesos_sim = simular_portfolios(mu, cov, NUM_PORTFOLIOS)

    # 6. Graficar y optimizar
    w_sharpe, w_minvar = graficar_frontera(resultados, mu, cov, top_tickers)

    # 7. Imprimir asignaciones optimas
    imprimir_asignacion("PORTFOLIO MAXIMO SHARPE RATIO", w_sharpe, top_tickers, mu, cov)
    imprimir_asignacion("PORTFOLIO MINIMA VARIANZA", w_minvar, top_tickers, mu, cov)

    # 8. Guardar tabla resumen en CSV
    df_resumen = pd.DataFrame({
        "Ticker": top_tickers,
        "Peso_MaxSharpe": w_sharpe,
        "Peso_MinVarianza": w_minvar,
        "Retorno_Anual": mu.values,
        "Volatilidad_Anual": np.sqrt(np.diag(cov.values)),
    }).round(4)
    df_resumen.to_csv("resumen_portfolios.csv", index=False)
    print("\nTabla resumen guardada en: resumen_portfolios.csv")

    if usando_muestra:
        print("\nNOTA: Se usaron datos sinteticos. Ejecuta en tu maquina local")
        print("      con acceso a internet para obtener datos reales de Yahoo Finance.")

    print("\n--- Proceso completado ---")
