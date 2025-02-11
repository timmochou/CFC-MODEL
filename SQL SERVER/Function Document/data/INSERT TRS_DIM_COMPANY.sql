MERGE [dbo].[TRS_DIM_COMPANY] AS target
USING (VALUES
    (N'BLUE', N'BLUE', N'BLUE', NULL, NULL, NULL, CAST(N'2006-09-21' AS Date), NULL, N'CN', NULL, NULL, NULL, NULL, N'CNY', N'true', NULL, NULL, N'admin', CAST(N'2025-01-24T15:28:42.530' AS DateTime), NULL),
    (N'BRVI', N'BRVI', N'BRVI', NULL, NULL, NULL, NULL, NULL, N'SG', NULL, NULL, NULL, NULL, N'USD', N'true', NULL, NULL, N'admin', CAST(N'2025-01-22T10:23:58.090' AS DateTime), NULL),
    (N'BRVM', N'BRVM', N'BRVM', NULL, NULL, NULL, NULL, NULL, N'MM', NULL, NULL, NULL, NULL, N'MMK', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'BSS', N'BSS', N'BSS', NULL, NULL, NULL, CAST(N'2010-03-18' AS Date), NULL, N'TW', NULL, NULL, NULL, NULL, N'TWD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'CLIPPER', N'CLIPPER', N'CLIPPER', NULL, NULL, NULL, CAST(N'2004-12-30' AS Date), NULL, N'CN', NULL, NULL, NULL, NULL, N'CNY', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'DAWIN', N'DAWIN', N'DAWIN', NULL, NULL, NULL, NULL, NULL, N'HK', NULL, NULL, NULL, NULL, N'HKD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'GZIT', N'GZIT', N'GZIT', NULL, NULL, NULL, NULL, NULL, N'CN', NULL, NULL, NULL, NULL, N'CNY', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'HCVN', N'HCVN', N'HCVN', NULL, NULL, NULL, NULL, NULL, N'VN', NULL, NULL, NULL, NULL, N'VND', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'IMIC', N'IMIC', N'IMIC', NULL, NULL, NULL, NULL, NULL, N'KY', NULL, NULL, NULL, NULL, N'USD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'SZYC', N'SZYC', N'SZYC', NULL, NULL, NULL, NULL, NULL, N'CN', NULL, NULL, NULL, NULL, N'CNY', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'TKL', N'TKL', N'TKL', NULL, NULL, NULL, CAST(N'2005-09-26' AS Date), NULL, N'TW', NULL, NULL, NULL, NULL, N'TWD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'UNIWIN', N'UNIWIN', N'UNIWIN', NULL, NULL, NULL, NULL, NULL, N'CN', NULL, NULL, NULL, NULL, N'CNY', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WGD', N'WGD', N'WGD', NULL, NULL, NULL, CAST(N'2024-06-17' AS Date), NULL, N'TH', NULL, NULL, NULL, NULL, N'THB', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHAZ', N'WHAZ', N'WHAZ', NULL, NULL, NULL, NULL, NULL, N'US', NULL, NULL, NULL, NULL, N'USD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHC', N'WHC', N'WHC', NULL, NULL, NULL, NULL, NULL, N'JP', NULL, NULL, NULL, NULL, N'JPY', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHEC', N'WHEC', N'WHEC', NULL, NULL, NULL, CAST(N'2021-01-01' AS Date), NULL, N'EC', NULL, NULL, NULL, NULL, N'USD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHHK', N'WHHK', N'WHHK', NULL, NULL, NULL, NULL, NULL, N'HK', NULL, NULL, NULL, NULL, N'HKD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHI', N'WHI', N'WHI', NULL, NULL, NULL, NULL, NULL, N'SG', NULL, NULL, NULL, NULL, N'SGD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHIN', N'WHIN', N'WHIN', NULL, NULL, NULL, NULL, NULL, N'IN', NULL, NULL, NULL, NULL, N'INR', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHKR', N'WHKR', N'WHKR', NULL, NULL, NULL, NULL, NULL, N'KR', NULL, NULL, NULL, NULL, N'KRW', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHL', N'WHL', N'WHL', NULL, NULL, NULL, CAST(N'1965-02-24' AS Date), NULL, N'TW', NULL, NULL, NULL, NULL, N'TWD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHLR', N'WHLR', N'WHLR', NULL, NULL, NULL, CAST(N'2022-11-16' AS Date), NULL, N'LR', NULL, NULL, NULL, NULL, N'USD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHMX', N'WHMX', N'WHMX', NULL, NULL, NULL, NULL, NULL, N'MX', NULL, NULL, NULL, NULL, N'MXN', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHMY', N'WHMY', N'WHMY', NULL, NULL, NULL, NULL, NULL, N'MY', NULL, NULL, NULL, NULL, N'MYR', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHPER', N'WHPER', N'WHPER', NULL, NULL, NULL, CAST(N'2015-05-14' AS Date), NULL, N'PE', NULL, NULL, NULL, NULL, N'PEN', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHPH', N'WHPH', N'WHPH', NULL, NULL, NULL, CAST(N'2000-10-05' AS Date), NULL, N'PH', NULL, NULL, NULL, NULL, N'PHP', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHSG', N'WHSG', N'WHSG', NULL, NULL, NULL, CAST(N'1991-05-09' AS Date), NULL, N'SG', NULL, NULL, NULL, NULL, N'USD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHSH', N'WHSH', N'WHSH', NULL, NULL, NULL, NULL, NULL, N'MM', NULL, NULL, NULL, NULL, N'MMK', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHTH', N'WHTH', N'WHTH', NULL, NULL, NULL, NULL, NULL, N'TH', NULL, NULL, NULL, NULL, N'THB', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHUSA', N'WHUSA', N'WHUSA', NULL, NULL, NULL, NULL, NULL, N'US', NULL, NULL, NULL, NULL, N'USD', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'WHVN', N'WHVN', N'WHVN', NULL, NULL, NULL, NULL, NULL, N'VN', NULL, NULL, NULL, NULL, N'VND', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL),
    (N'YIMY', N'YIMY', N'YIMY', NULL, NULL, NULL, NULL, NULL, N'MY', NULL, NULL, NULL, NULL, N'MYR', N'true', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:51:35.610' AS DateTime), NULL)
) AS source (
    [COMPANY_ID], [COMPANY_CODE], [COMPANY_DISPLAY], [BUSINESS_TYPE], [INDUSTRY], 
    [BUSINESS_STATUS], [START_DATE], [CANCELLATION_DATE], [COUNTRY_ID], [REGION_ID], 
    [LEGAL_REPRESENTATIVE], [CONTACT_NUMBER], [REGISTRATION_DATE], [LOCAL_CURRENCY_ID], 
    [IS_ACTIVE], [CREATED_BY], [CREATED_TIME], [UPDATED_BY], [UPDATED_TIME], [PRE_CODE]
)
ON target.[COMPANY_ID] = source.[COMPANY_ID]
WHEN MATCHED THEN
    UPDATE SET
        [COMPANY_CODE] = source.[COMPANY_CODE],
        [COMPANY_DISPLAY] = source.[COMPANY_DISPLAY],
        [BUSINESS_TYPE] = source.[BUSINESS_TYPE],
        [INDUSTRY] = source.[INDUSTRY],
        [BUSINESS_STATUS] = source.[BUSINESS_STATUS],
        [START_DATE] = source.[START_DATE],
        [CANCELLATION_DATE] = source.[CANCELLATION_DATE],
        [COUNTRY_ID] = source.[COUNTRY_ID],
        [REGION_ID] = source.[REGION_ID],
        [LEGAL_REPRESENTATIVE] = source.[LEGAL_REPRESENTATIVE],
        [CONTACT_NUMBER] = source.[CONTACT_NUMBER],
        [REGISTRATION_DATE] = source.[REGISTRATION_DATE],
        [LOCAL_CURRENCY_ID] = source.[LOCAL_CURRENCY_ID],
        [IS_ACTIVE] = source.[IS_ACTIVE],
        [CREATED_BY] = source.[CREATED_BY],
        [CREATED_TIME] = source.[CREATED_TIME],
        [UPDATED_BY] = source.[UPDATED_BY],
        [UPDATED_TIME] = source.[UPDATED_TIME],
        [PRE_CODE] = source.[PRE_CODE]
WHEN NOT MATCHED THEN
    INSERT (
        [COMPANY_ID], [COMPANY_CODE], [COMPANY_DISPLAY], [BUSINESS_TYPE], [INDUSTRY],
        [BUSINESS_STATUS], [START_DATE], [CANCELLATION_DATE], [COUNTRY_ID], [REGION_ID],
        [LEGAL_REPRESENTATIVE], [CONTACT_NUMBER], [REGISTRATION_DATE], [LOCAL_CURRENCY_ID],
        [IS_ACTIVE], [CREATED_BY], [CREATED_TIME], [UPDATED_BY], [UPDATED_TIME], [PRE_CODE]
    )
    VALUES (
        source.[COMPANY_ID], source.[COMPANY_CODE], source.[COMPANY_DISPLAY], source.[BUSINESS_TYPE],
        source.[INDUSTRY], source.[BUSINESS_STATUS], source.[START_DATE], source.[CANCELLATION_DATE],
        source.[COUNTRY_ID], source.[REGION_ID], source.[LEGAL_REPRESENTATIVE], source.[CONTACT_NUMBER],
        source.[REGISTRATION_DATE], source.[LOCAL_CURRENCY_ID], source.[IS_ACTIVE], source.[CREATED_BY],
        source.[CREATED_TIME], source.[UPDATED_BY], source.[UPDATED_TIME], source.[PRE_CODE]
    );