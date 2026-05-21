%%pyspark
# ============================================================
# CREATE TABLE Gold.bgla_FactClaim (si no existe)
# DDL completo — todos los campos numéricos en DOUBLE
# ============================================================
spark.sql("""
    CREATE TABLE IF NOT EXISTS Gold.bgla_FactClaim (
    -- ── Keys ──
    FactClaimSKey                           STRING,
    ClaimDetailId                           INT,
    LogId                                   BIGINT,
    ClaimLineDetailId                       BIGINT,
    ClaimLineSequenceNumber                 INT,
    ClaimVersion                            INT,
    ClaimReferralHeaderId                   BIGINT,
    ClaimUUID                               STRING,
    ClaimHeaderId                           BIGINT,
    ClaimNumber                             BIGINT,

    -- ── Dimension Surrogate Keys ──
    ClaimStatusSKey                         STRING,
    ClaimReasonSKey                         STRING,
    ClaimStatusReasonDatekey                BIGINT,
    ClaimMemberSKey                         STRING,
    ClaimBillingProviderSkey                STRING,
    ClaimServiceProviderSKey                STRING,
    ClaimScheduleSKey                       STRING,
    ClaimServiceFromDateKey                 BIGINT,
    ClaimServiceToDate                      DATE,
    ClaimNetworkSkey                        STRING,
    ClaimLineDetailServiceindicatorSkey     STRING,
    ClaimReportingServiceindicatorSkey      STRING,
    ClaimPrimaryDiagnosticSkey              STRING,
    ClaimPrimaryProcedureSkey               STRING,
    ClaimPlaceOfServiceSKey                 STRING,
    ClaimTypeOfServiceSKey                  STRING,
    ClaimPrioritySkey                       STRING,
    ClaimReceivedDateKey                    BIGINT,
    ClaimGeographySKey                      STRING,
    ClaimAccumulatorScopeSKey               STRING,
    ClaimBillTypeSKey                       STRING,
    ClaimPayToSKey                          STRING,
    ClaimPayeeSkey                          STRING,

    -- ── Claim Detail Fields ──
    ClaimAccountNumber                      STRING,
    MemberPPA                               DOUBLE,
    ProviderPPA                             DOUBLE,
    PolicySKey                              STRING,
    ClaimReferenceNumber                    STRING,
    ClaimPenalty                            INT,
    ClaimQuantity                           DOUBLE,

    -- ── Currency Keys ──
    ClaimLocalCurrencySKey                  STRING,
    ClaimBaseCurrencySkey                   STRING,
    ClaimXchangeRateDateKey                 BIGINT,

    -- ── Amounts ──
    ClaimBilledAmountLocalCurrency          DOUBLE,
    ClaimBilledAmountLocalCurrencyUSD       DOUBLE,
    ClaimXchangeRate                        DOUBLE,
    ClaimBilledAmountBaseCurrency           DOUBLE,
    ClaimBilledAmountBaseCurrencyUSD        DOUBLE,
    ClaimIneligAmount                       DOUBLE,
    ClaimIneligAmountUSD                    DOUBLE,
    ClaimPrepaidAmount                      DOUBLE,
    ClaimPrepaidAmountUSD                   DOUBLE,
    ClaimCoInsuranceAmount                  DOUBLE,
    ClaimCoInsuranceAmountUSD               DOUBLE,
    ClaimDeductibleAmount                   DOUBLE,
    ClaimDeductibleAmountUSD                DOUBLE,
    ClaimAllowedAmount                      DOUBLE,
    ClaimAllowedAmountUSD                   DOUBLE,
    ClaimCoveredAmount                      DOUBLE,
    ClaimCoveredAmountUSD                   DOUBLE,
    ClaimNetCoveredAmount                   DOUBLE,
    ClaimNetCoveredAmountUSD                DOUBLE,
    ClaimDiscountsAmount                    DOUBLE,
    ClaimDiscountsAmountUSD                 DOUBLE,
    ClaimNonCoveredAmount                   DOUBLE,
    ClaimNonCoveredAmountUSD                DOUBLE,
    ClaimMemberLiabilityAmount              DOUBLE,
    ClaimMemberLiabilityAmountUSD           DOUBLE,
    ClaimProviderLiabilityAmount            DOUBLE,
    ClaimProviderLiabilityAmountUSD         DOUBLE,
    ClaimMemberPaymentAmount                DOUBLE,
    ClaimMemberPaymentAmountUSD             DOUBLE,
    ClaimMemberPaymentCurrencySkey          STRING,
    ClaimMemberPaymentAmountCurrency        DOUBLE,
    ClaimMemberPaymentAmountCurrencyUSD     DOUBLE,
    ClaimMemberPaymentXchangeRate           DOUBLE,
    ClaimProviderPaymentAmount              DOUBLE,
    ClaimProviderPaymentAmountUSD           DOUBLE,
    ClaimProviderPaymentCurrencySkey        STRING,
    ClaimProviderPaymentAmountCurrency      DOUBLE,
    ClaimProviderPaymentAmountCurrencyUSD   DOUBLE,
    ClaimProviderPaymentXchangeRate         DOUBLE,
    ClaimCOBPrePaidAmount                   DOUBLE,
    ClaimCOBPrePaidAmountUSD                DOUBLE,
    ClaimOtherPrePaidAmount                 DOUBLE,
    ClaimOtherPrePaidAmountUSD              DOUBLE,

    -- ── Processed ──
    ClaimProcessedDateSkey                  STRING,
    ControlVersion                          STRING,
    ClaimProcessedStatusSkey                STRING,
    ClaimProcessedReasonSkey                STRING,

    -- ── Submission ──
    InOnNetwork                             STRING,
    SubmissionInboundChannel                STRING,
    SubmissionTrackingNumber                STRING,
    SubmissionSenderType                    STRING,
    SubmissionSenderEmailAddress            STRING,
    SubmissionSenderFullName                STRING,
    SubmissionReceivedDatekey               BIGINT,
    SubmissionIsComplement                  BOOLEAN,
    ServiceNetwork                          STRING,

    -- ── Business Flags ──
    ClaimGap                                INT,
    ClaimReceivedMethodSKey                 STRING,
    PolicyFirstYear                         INT,
    PolicyFirstMonth                        INT,
    FirstClaim                              INT,
    IsDigital                               INT,
    ServiceNetworkSKey                      STRING,
    IsFastTrack                             BOOLEAN,
    HTHFeePaid                              DOUBLE,
    HTHFeePercent                           DOUBLE,
    IsDeleted                               INT,
    ProviderNetworkClassName                STRING,
    SavingAmount                            DOUBLE,
    BrackedClaimKey                         STRING,
    BrackedMemberKey                        STRING,
    `IncomebyinsuredIA`                     DOUBLE,
    `SpendbyinsuredGA`                      DOUBLE,
    ClaimValidation                         STRING,

    -- ── Clinical Flags ──
    IsICU                                   INT,
    IsEmergency                             INT,
    IsHospital_Emergency                    INT,
    IsChildbirths                           INT,
    IsCesareanSection                       INT,

    -- ── Lot / ClearingHouse ──
    BatchLotName                            STRING,
    BatchLotFromDate                        DATE,
    TransactionLotReceivedDate              DATE,
    TransactionLotNumber                    STRING,
    TransactionInvoiceNumber                STRING,
    LotNumber                               STRING,
    IsAutomatic                             INT,
    FirstYearClaimExceptions                STRING,
    ClaimsOutliers                          INT,

    -- ── Source IDs ──
    PolicyId                                INT,
    MemberId                                INT,

    -- ── WithHolding / VAT ──
    BaseWithHolding                         DOUBLE,
    BaseVAT                                 DOUBLE,
    ThirdPartyId                            INT,

    -- ── TAT: LocalTeam / IsCOR ──
    LocalTeam                               STRING,
    IsCOR                                   STRING,

    -- ── BISI Coinsurance ──
    ClaimCoInsuranceBISIAmount              DOUBLE,
    ClaimCoInsuranceBISIAmountUSD           DOUBLE,
    CoverageId                              INT,
    HigthCostClaim                          INT,

    -- ── Payment Posted ──
    PaymentPostedDateKey                    BIGINT,
    PaymentPostedDate                       DATE,

    -- ── Deductible Override ──
    DeductibleOverrideCreatedOn             DATE,
    DeductibleOverrideCreatedBy             STRING,
    DeductibleOverrideCreatedByUserFullName STRING,
    DeductibleOverrideApprovedOn            DATE,
    DeductibleOverrideApprovedBy            STRING,
    DeductibleOverrideApprovedByUserName    STRING,
    DeductibleOverrideReasonCode            STRING,
    DeductibleOverrideReasonDescription     STRING,

    -- ── Misc ──
    UpdatedBy                               STRING,
    ClaimType                               STRING,
    IssuedDate                              DATE,
    ActionDate                              DATE,

    -- ── Policy Dimension SKeys ──
    PolicyEntitySKey                        STRING,
    PolicyGroupSKey                         STRING,
    PolicyProductSKey                       STRING,
    PolicyPlanSKey                          STRING,
    PolicyBusinessModeSKey                  STRING,
    PolicyBusinessTypeSKey                  STRING,
    PolicyInsuranceBusinessSKey             STRING,
    PolicyCompanySKey                       STRING,
    PolicyAgentSKey                         STRING,
    PolicyRegionSkey                        STRING,
    PolicyModeOfPaymentSKey                 STRING,
    PolicyPaymentMethodSKey                 STRING,
    PolicyReceivedMethodSKey                STRING,
    PolicyFamilyTypeSKey                    STRING,

    -- ── Policy Date Keys ──
    PolicyIssueDateKey                      BIGINT,
    PolicyRenewalDateKey                    BIGINT,
    PolicyAnniversaryDateKey                BIGINT,
    PolicyApplicationReceivedDateKey        BIGINT,
    PolicyEffectiveDateKey                  BIGINT,
    PolicyCancelDateKey                     BIGINT,
    PolicyDeathBenefitperiodDateKey         BIGINT,

    -- ── ThirdParty + SeverityBracket ──
    PaymentThirdPartySKey                   STRING,
    SeverityBracketSKey                     STRING,

    -- ── VAT/Withholding USD ──
    VATBaseCurrenty                         DOUBLE,
    VATUSDCurrenty                          DOUBLE,
    WithholdingBaseCurrenty                 DOUBLE,
    WithholdingUSDCurrenty                  DOUBLE,

    -- ── ClaimUpdatedByUser + Source ──
    ClaimUpdatedByUser                      STRING,
    Source                                  STRING,

    -- ── SCD Fields ──
    ActualRowFlag                           INT,
    EffectiveDate                           DATE,
    LoadDate                                TIMESTAMP
)
USING DELTA
""")
print("[OK] Gold.bgla_FactClaim table ensured")
