%%pyspark
# ============================================================
# CREATE TABLE Gold.bgla_FactClaimPayment (si no existe)
# DDL completo — todos los campos numéricos en DOUBLE
# ============================================================
spark.sql("""
CREATE TABLE IF NOT EXISTS Gold.bgla_FactClaimPayment (
    -- ── Identificadores principales ──
    FactClaimPaymentSKey                                STRING,
    ClaimHeaderId                                       INT,
    ClaimNumber                                         INT,
    ClaimAccountNumber                                  STRING,
    ClaimReferenceNumber                                STRING,
    ClaimDetailId                                       INT,
    ClaimVersion                                        INT,
    ClaimLineDetailId                                   INT,
    ClaimLineSequenceNumber                             INT,
    ClamReferralHeaderId                                INT,
    ClaimUUID                                           STRING,

    -- ── Claim status / member / provider / schedule / network ──
    ClaimStatusSKey                                     STRING,
    ClaimReasonSKey                                     STRING,
    ClaimStatusReasonDateKey                            INT,
    ClaimMemberEligibilitySKey                          STRING,
    ClaimBillingProviderSkey                            STRING,
    ClaimServiceProviderSKey                            STRING,
    ClaimScheduleSKey                                   STRING,
    ClaimNetworkSkey                                    STRING,
    ClaimDetailServiceIndicatorSkey                     STRING,
    ClaimLineDetailServiceIndicatorSkey                 STRING,

    -- ── Service dates / monedas / geografía ──
    ClaimServiceFromDateKey                             INT,
    ClaimServiceFromDate                                TIMESTAMP,
    ClaimServiceToDate                                  TIMESTAMP,
    ClaimBaseCurrencySKey                               STRING,
    ClaimLocalCurrencySKey                              STRING,
    ClaimReceivedDateKey                                INT,
    ClaimGeographySKey                                  STRING,

    -- ── Acumuladores y tipos ──
    ClaimAccumulatorScopeSKey                           STRING,
    ClaimBillTypeSKey                                   STRING,
    ClaimPayToSkey                                      STRING,
    ClaimPayeeSkey                                      STRING,

    -- ── Policy ──
    PolicySKey                                          STRING,
    PolicyModeOfPaymentSKey                             STRING,
    PolicyPaymentMethodSKey                             STRING,
    PolicyReceivedMethodSKey                            STRING,
    PolicyGroupSKey                                     STRING,
    PolicyFamilyTypeSKey                                STRING,
    PolicyProductSKey                                   STRING,
    PolicyEntitySKey                                    STRING,
    PolicyPlanSKey                                      STRING,
    PolicyBusinessModeSKey                              STRING,
    PolicyBusinessTypeSKey                              STRING,
    PolicyInsuranceBusinessSKey                         STRING,
    PolicyCompanySKey                                   STRING,
    PolicyIssueDateKey                                  INT,
    PolicyRenewalDateKey                                INT,
    PolicyAnniversaryDateKey                            INT,
    PolicyApplicationReceivedDateKey                    INT,
    PolicyEffectiveDateKey                              INT,
    PolicyCancelDateKey                                 INT,
    PolicyDeathBenefitperiodDateKey                     INT,
    PolicyAgentSKey                                     STRING,
    PolicyRegionSkey                                    STRING,
    PolicyMemberOwnerEligibilitySKey                    STRING,
    PolicyGeographySKey                                 STRING,

    -- ── Claim Run ──
    ClaimRunId                                          INT,
    ClaimDetailRunId                                    INT,
    ClaimRunTypeSkey                                    STRING,
    ClaimRunCreatedOnDateSkey                           STRING,
    ClaimRunPrintedOnDateSkey                           STRING,
    ClaimRunStatusSKey                                  STRING,
    ClaimRunPaymentMethodSkey                           STRING,

    -- ── Diagnóstico / procedimiento / POS / TOS ──
    ClaimPrimaryDiagnosticSKey                          STRING,
    ClaimPrimaryProcedureSKey                           STRING,
    ClaimLineDetail_DiagnosticType                      INT,
    ClaimLineDetail_POSId                               INT,
    ClaimLineDetail_TOSId                               INT,

    -- ── Servicio / red ──
    ServiceNetwork                                      STRING,
    Paid_To_Calculated                                  STRING,
    InOnNetwork                                         STRING,

    -- ── Payment ──
    PaymentId                                           INT,
    PaymentNumber                                       INT,
    PaymentPostedDateKey                                INT,
    PaymentPrintedDateKey                               INT,
    PaymentStatusSKey                                   STRING,
    PaymentVoidReasonSkey                               STRING,
    PaymentVoidDateSKey                                 STRING,
    JournalEntryId                                      INT,
    JournalEntryNotes                                   STRING,

    -- ── Monedas de pago ──
    ClaimMemberPaymentCurrencySkey                      STRING,
    ClaimProviderPaymentCurrencySkey                    STRING,
    ClaimMemberPaymentXchangeRate                       DOUBLE,
    ClaimProviderPaymentXchangeRate                     DOUBLE,
    PaymentThirdPartySKey                               STRING,
    ClaimProcessedDateSkey                              STRING,

    -- ── Montos en moneda local ──
    LocalBilledAmount                                   DOUBLE,

    -- ── Montos Base Currency ──
    ClaimAllowedAmountBaseCurrency                      DOUBLE,
    ClaimBilledAmountBaseCurrency                       DOUBLE,
    ClaimCoInsuranceAmountBaseCurrency                  DOUBLE,
    ClaimAllowedCmpBaseCurrency                         DOUBLE,
    ClaimCopayAmountBaseCurrency                        DOUBLE,
    ClaimDeductibleAmountBaseCurrency                   DOUBLE,
    ClaimNetCoveredAmountBaseCurrency                   DOUBLE,
    ClaimMemberPaidAmountBaseCurrency                   DOUBLE,
    ClaimProviderPaidAmountBaseCurrency                 DOUBLE,
    ClaimTotalIneligibleAmountBaseCurrency              DOUBLE,
    ClaimTotalOtherIneligibleAmountBaseCurrency         DOUBLE,
    ClaimTotalPaidAmountBaseCurrency                    DOUBLE,

    -- ── Montos Payment Currency ──
    ClaimMemberPaidAmountPaymentCurrency                DOUBLE,
    ClaimProviderPaidAmountPaymentCurrency              DOUBLE,

    -- ── Montos USD Currency ──
    ClaimAllowedAmountUSDCurrency                       DOUBLE,
    ClaimBilledAmountUSDCurrency                        DOUBLE,
    ClaimCoInsuranceAmountUSDCurrency                   DOUBLE,
    ClaimAllowedCmpUSDCurrency                          DOUBLE,
    ClaimCopayAmountUSDCurrency                         DOUBLE,
    ClaimDeductibleAmountUSDCurrency                    DOUBLE,
    ClaimMemberPaidAmountUSDCurrency                    DOUBLE,
    ClaimNetCoveredAmountUSDCurrency                    DOUBLE,
    ClaimProviderPaidAmountUSDCurrency                  DOUBLE,
    ClaimTotalIneligibleAmountUSDCurrency               DOUBLE,
    ClaimTotalOtherIneligibleAmountUSDCurrency          DOUBLE,
    ClaimTotalPaidAmountUSDCurrency                     DOUBLE,

    -- ── Ajustes Provider ──
    ClaimProviderPaymentAdjustedAmountBaseCurrenty      DOUBLE,
    ClaimProviderPaymentAdjustedAmountPaymentCurrency   DOUBLE,
    ClaimProviderPaymentAdjustedAmountUSDCurrency       DOUBLE,

    -- ── Ajustes Member ──
    ClaimMemberPaymentAdjustedAmountBaseCurrenty        DOUBLE,
    ClaimMemberPaymentAdjustedAmountPaymentCurrency     DOUBLE,
    ClaimMemberPaymentAdjustedAmountUSDCurrency         DOUBLE,

    -- ── PPA Balances ──
    ClaimProviderPPABalanceBaseCurrenty                 DOUBLE,
    ClaimProviderPPABalancePaymentCurrency              DOUBLE,
    ClaimMemberPPABalanceBaseCurrenty                   DOUBLE,
    ClaimMemberPPABalancePaymentCurrency                DOUBLE,
    ClaimProviderVoidPPABalanceBaseCurrenty             DOUBLE,
    ClaimProviderVoidPPABalancePaymentCurrency          DOUBLE,
    ClaimMemberVoidPPABalanceBaseCurrenty               DOUBLE,
    ClaimMemberVoidPPABalancePaymentCurrency            DOUBLE,

    -- ── Flags / metadatos ──
    ClaimProcessRowFlag                                 INT,
    Source                                              STRING,
    EffectiveDate                                       DATE,
    LoadDate                                            TIMESTAMP,
    ActualRowFlag                                       INT,
    ClaimRunInsuranceBusinessSKey                       STRING,

    -- ── Pago / banco ──
    PaymentGatewayTransactionId                         DOUBLE,
    PaymentAmount                                       DOUBLE,
    PaymentForeignAmount                                DOUBLE,
    PaymentBankTransmissionId                           INT,
    ClaimLocalXChangeRate                               DOUBLE,
    ClaimLocalXChangeDate                               TIMESTAMP,
    ControlVersion                                      INT,
    PaidSource                                          STRING,

    -- ── VAT / Withholding ──
    VATPaymentCurrency                                  DOUBLE,
    VATBaseCurrenty                                     DOUBLE,
    VATUSDCurrenty                                      DOUBLE,
    WithholdingPaymentCurrency                          DOUBLE,
    WithholdingBaseCurrenty                             DOUBLE,
    WithholdingUSDCurrenty                              DOUBLE,

    -- ── Member / descuentos / gap ──
    MemberId                                            INT,
    ClaimTotalDiscountAmountUSDCurrency                 DOUBLE,
    ClaimTotalDiscountAmount                            DOUBLE,
    ClaimGap                                            INT,
    ClaimReceivedMethodSKey                             STRING,

    -- ── Atributos de Policy / Claim flags ──
    PolicyFirstYear                                     INT,
    PolicyFirstMonth                                    INT,
    FistClaim                                           INT,
    IsDigital                                           INT,
    ServiceNetworkSKey                                  STRING,
    IsCOR                                               STRING,
    LocalTeam                                           STRING,
    ClaimsOutliers                                      BIGINT,
    IsFastTrack                                         BOOLEAN,
    HTHFeePaid                                          DOUBLE,
    HTHFeePercent                                       DOUBLE,
    IsDeleted                                           INT,
    ProviderNetworkClassName                            STRING,
    SavingAmount                                        DOUBLE,
    `IncomebyinsuredIA`                                 DOUBLE,
    `SpendbyinsuredGA`                                  DOUBLE,
    BrackedClaimKey                                     STRING,
    BrackedMemberKey                                    STRING,

    -- ── Submission ──
    SubmissionSenderEmailAddress                        STRING,
    SubmissionSenderFullName                            STRING,
    SubmissionInboundChannel                            STRING,
    SubmissionTrackingNumber                            STRING,
    SubmissionSenderType                                STRING,
    ClaimValidation                                     STRING,

    -- ── Lotes / transacciones ──
    BatchLotName                                        STRING,
    BatchLotFromDate                                    TIMESTAMP,
    TransactionLotReceivedDate                          TIMESTAMP,
    TransactionLotNumber                                STRING,
    TransactionInvoiceNumber                            STRING,
    LotNumber                                           STRING,
    IsAutomatic                                         BOOLEAN,

    -- ── Indicadores clínicos ──
    IsICU                                               INT,
    IsEmergency                                         INT,
    IsHospital_Emergency                                INT,
    IsChildbirths                                       INT,
    IsCesareanSection                                   INT,

    -- ── Service / POS ──
    ClaimTypeOfServiceSKey                              STRING,
    ClaimPlaceOfServiceSKey                             STRING,
    PolicyId                                            INT
)
USING DELTA
""")
print("[OK] Gold.bgla_FactClaimPayment table ensured")
