MERGE INTO [dbo].[TRS_DIM_ENTITY_I18N] AS target
USING (
    VALUES 
    (N'21e5b4fa-d994-4ae1-b71f-635c5a0b0f53', N'BLUE', N'勁海物流(上海)有限公司', N'zh_TW', NULL, NULL, N'admin', CAST(N'2025-01-24T15:28:42.537' AS DateTime)),
    (N'3b406be4-49a6-445c-856d-998b3a9ae9cc', N'BRVI', N'Bravely International Pte. Ltd.', N'zh_TW', NULL, NULL, N'admin', CAST(N'2025-01-22T10:23:58.097' AS DateTime)),
    (N'BLUE_tax_cbcr1_en_US', N'BLUE_tax_cbcr1', N'BLUE OCEAN LOGISTICS (SHANGHAI) LTD', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BLUEen_US', N'BLUE', N'勁海物流(上海)有限公司', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BRVI_tax_cbcr1_en_US', N'BRVI_tax_cbcr1', N'Bravely International Pte Ltd', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BRVI_tax_cbcr1_zh_TW', N'BRVI_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BRVIen_US', N'BRVI', N'Bravely International Pte. Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BRVM_tax_cbcr1_en_US', N'BRVM_tax_cbcr1', N'BRAVELY (MYANMAR) TRANSPORT AND LOGISTICS COMPANY LIMITED', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BRVM_tax_cbcr1_zh_TW', N'BRVM_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BRVMen_US', N'BRVM', N'Bravely (Myanmar) Transport and Logistics Company Limited.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BRVMzh_TW', N'BRVM', N'Bravely (Myanmar) Transport and Logistics Company Limited.', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BSS_tax_cbcr1_en_US', N'BSS_tax_cbcr1', N'BAO SHENG SHIPPING AGENCY CO., LTD.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BSS_tax_cbcr1_zh_TW', N'BSS_tax_cbcr1', N'寶昇船務代理股份有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BSSen_US', N'BSS', N'BS', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'BSSzh_TW', N'BSS', N'寶昇船務代理股份有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'CLIPPER_tax_cbcr1_en_US', N'CLIPPER_tax_cbcr1', N'CLIPPER INTERNATIONAL SHIPPING AGENCY LTD.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'CLIPPER_tax_cbcr1_zh_TW', N'CLIPPER_tax_cbcr1', N'上海聯駿國際船舶代理有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'CLIPPERen_US', N'CLIPPER', N'Clipper International Shipping Agency Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'CLIPPERzh_TW', N'CLIPPER', N'上海聯駿國際船舶代理有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'DAWIN_tax_cbcr1_en_US', N'DAWIN_tax_cbcr1', N'DAWIN LOGISTICS (INTERNATIONAL) LIMITED', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'DAWIN_tax_cbcr1_zh_TW', N'DAWIN_tax_cbcr1', N'大榮國際物流有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'DAWINen_US', N'DAWIN', N'Dawin Logistics (International) Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'DAWINzh_TW', N'DAWIN', N'大榮國際物流有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'fc914323-c3bf-4d40-9bed-72cc46bd051b', N'BLUE_tax_cbcr1', N'勁海物流(上海)有限公司', N'zh_TW', NULL, NULL, N'admin', CAST(N'2025-01-22T10:34:41.517' AS DateTime)),
    (N'GZIT_tax_cbcr1_en_US', N'GZIT_tax_cbcr1', N'GUANGZHOU WAN HAI INFORMATION TECHNOLOGY LTD.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'GZIT_tax_cbcr1_zh_TW', N'GZIT_tax_cbcr1', N'廣州萬海資訊科技有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'GZITen_US', N'GZIT', N'廣州萬海資訊科技有限公司', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'GZITzh_TW', N'GZIT', N'廣州萬海資訊科技有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'HCVN_tax_cbcr1_en_US', N'HCVN_tax_cbcr1', N'HE CHUN LOGISTICS COMPANY LIMITED', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'HCVN_tax_cbcr1_zh_TW', N'HCVN_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'HCVNen_US', N'HCVN', N'HE CHUN LOGISTICS COMPANY LIMITED', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'HCVNzh_TW', N'HCVN', N'和春櫃場有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'IMIC_tax_cbcr1_en_US', N'IMIC_tax_cbcr1', N'Infinite Marine Investment Co., Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'IMIC_tax_cbcr1_zh_TW', N'IMIC_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'IMICen_US', N'IMIC', N'Infinite Marine Investment Co., Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'IMICzh_TW', N'IMIC', N'Infinite Marine Investment Co., Ltd.', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'SZYC_tax_cbcr1_en_US', N'SZYC_tax_cbcr1', N'Shenzhen Yong Chun International Shipping Management Co., Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'SZYC_tax_cbcr1_zh_TW', N'SZYC_tax_cbcr1', N'深圳勇春國際船舶管理有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'SZYCen_US', N'SZYC', N'深圳勇春國際船舶管理有限公司', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'SZYCzh_TW', N'SZYC', N'深圳勇春國際船舶管理有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'TKL_tax_cbcr1_en_US', N'TKL_tax_cbcr1', N'TK LOGISTICS INTERNATIONAL CO., LTD.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'TKL_tax_cbcr1_zh_TW', N'TKL_tax_cbcr1', N'台基國際物流股份有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'TKLen_US', N'TKL', N'TK Logistics International Co., Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'TKLzh_TW', N'TKL', N'台基國際物流股份有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'UNIWIN_tax_cbcr1_en_US', N'UNIWIN_tax_cbcr1', N'SHENZHEN UNIWIN INTERNATIONAL LOGISTICS LTD.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'UNIWIN_tax_cbcr1_zh_TW', N'UNIWIN_tax_cbcr1', N'深圳聯豐國際貨運有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'UNIWINen_US', N'UNIWIN', N'深圳聯豐國際貨運有限公司', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'UNIWINzh_TW', N'UNIWIN', N'深圳聯豐國際貨運有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WGDen_US', N'WGD', N'WGD Container Service (Thailand) Co., Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WGDzh_TW', N'WGD', N'WGD Container Service (Thailand) Co., Ltd.', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHAZ_tax_cbcr1_en_US', N'WHAZ_tax_cbcr1', N'WAN HAI LINES (ARIZONA) LLC', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHAZ_tax_cbcr1_zh_TW', N'WHAZ_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHAZen_US', N'WHAZ', N'Wan Hai Lines (Arizona) LLC.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHAZzh_TW', N'WHAZ', N'Wan Hai Lines (Arizona) LLC.', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHC_tax_cbcr1_en_US', N'WHC_tax_cbcr1', N'WH Corporation', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHC_tax_cbcr1_zh_TW', N'WHC_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHCen_US', N'WHC', N'k.k. WH Corporation', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHCzh_TW', N'WHC', N'株式會社WH Corporation', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHEC_tax_cbcr1_en_US', N'WHEC_tax_cbcr1', N'WANHAI LINES ECUADOR S.A.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHEC_tax_cbcr1_zh_TW', N'WHEC_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHECen_US', N'WHEC', N'WanHai Lines Ecuador S.A.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHECzh_TW', N'WHEC', N'萬海航運(厄瓜多)股份有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHHK_tax_cbcr1_en_US', N'WHHK_tax_cbcr1', N'Wan Hai Lines (H.K.) Limited', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHHK_tax_cbcr1_zh_TW', N'WHHK_tax_cbcr1', N'萬海航運(香港)股份有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHHKen_US', N'WHHK', N'Wan Hai Lines (H.K.) Limited', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHHKzh_TW', N'WHHK', N'萬海航運(香港)股份有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHI_tax_cbcr1_en_US', N'WHI_tax_cbcr1', N'Wan Hai International Pte Ltd', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHI_tax_cbcr1_zh_TW', N'WHI_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHIen_US', N'WHI', N'Wan Hai International Pte. Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHIN_tax_cbcr1_en_US', N'WHIN_tax_cbcr1', N'Wan Hai Lines (India) Pvt. Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHIN_tax_cbcr1_zh_TW', N'WHIN_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHINen_US', N'WHIN', N'Wan Hai Lines (India) PVT Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHINzh_TW', N'WHIN', N'萬海航運(印度)有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHIzh_TW', N'WHI', N'萬海國際有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHKR_tax_cbcr1_en_US', N'WHKR_tax_cbcr1', N'Wan Hai Lines (Korea) Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHKR_tax_cbcr1_zh_TW', N'WHKR_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHKRen_US', N'WHKR', N'Wan Hai Lines (Korea) Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHKRzh_TW', N'WHKR', N'萬海航運韓國株式會社', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHL_tax_cbcr1_en_US', N'WHL_tax_cbcr1', N'WAN HAI LINES LTD.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHL_tax_cbcr1_zh_TW', N'WHL_tax_cbcr1', N'萬海航運股份有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHLen_US', N'WHL', N'Wan Hai Lines Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHLR_tax_cbcr1_en_US', N'WHLR_tax_cbcr1', N'WAN HAI LINES (LIBERIA) LTD.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHLR_tax_cbcr1_zh_TW', N'WHLR_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHLRen_US', N'WHLR', N'Wan Hai Lines (Liberia) Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHLRzh_TW', N'WHLR', N'萬海航運(賴比瑞亞)有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHLzh_TW', N'WHL', N'萬海航運股份有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHMX_tax_cbcr1_en_US', N'WHMX_tax_cbcr1', N'Wan Hai Lines Mexico, S. A. DE C. V.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHMX_tax_cbcr1_zh_TW', N'WHMX_tax_cbcr1', N'Wan Hai Lines Mexico, S. A. DE C. V.', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHMXen_US', N'WHMX', N'WAN HAI LINES MEXICO S.A. DE C.V.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHMXzh_TW', N'WHMX', N'萬海航運(墨西哥)股份有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHMY_tax_cbcr1_en_US', N'WHMY_tax_cbcr1', N'Wan Hai Lines (M) Sdn Bhd', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHMY_tax_cbcr1_zh_TW', N'WHMY_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHMYen_US', N'WHMY', N'Wan Hai Lines (M) Sdn. Bhd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHMYzh_TW', N'WHMY', N'萬海航運(馬來西亞)有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHPER_tax_cbcr1_en_US', N'WHPER_tax_cbcr1', N'WAN HAI LINES PERU S.A.C.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHPER_tax_cbcr1_zh_TW', N'WHPER_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHPERen_US', N'WHPER', N'WAN HAI LINES PERU S.A.C.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHPERzh_TW', N'WHPER', N'WAN HAI LINES PERU S.A.C.', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHPH_tax_cbcr1_en_US', N'WHPH_tax_cbcr1', N'WAN HAI LINES (PHILS.), INC.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHPH_tax_cbcr1_zh_TW', N'WHPH_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHPHen_US', N'WHPH', N'Wan Hai Lines (Phils.), Inc.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHPHzh_TW', N'WHPH', N'萬海航運(菲律賓)有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHSG_tax_cbcr1_en_US', N'WHSG_tax_cbcr1', N'Wan Hai Lines (Singapore) Pte Ltd', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHSG_tax_cbcr1_zh_TW', N'WHSG_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHSGen_US', N'WHSG', N'Wan Hai Lines (Singapore) Pte. Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHSGzh_TW', N'WHSG', N'萬海航運(新加坡)有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHSH_tax_cbcr1_en_US', N'WHSH_tax_cbcr1', N'WAN HAI SHIPPING LIMITED', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHSH_tax_cbcr1_zh_TW', N'WHSH_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHSHen_US', N'WHSH', N'WAN HAI SHIPPING LIMITED', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHSHzh_TW', N'WHSH', N'WAN HAI SHIPPING LIMITED', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHTH_tax_cbcr1_en_US', N'WHTH_tax_cbcr1', N'WAN HAI LINES (THAILAND) LTD', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHTH_tax_cbcr1_zh_TW', N'WHTH_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHTHen_US', N'WHTH', N'Wan Hai Lines (Thailand) Limited', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHTHzh_TW', N'WHTH', N'萬海航運(泰國)有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHUSA_tax_cbcr1_en_US', N'WHUSA_tax_cbcr1', N'WAN HAI LINES (USA) LTD', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHUSA_tax_cbcr1_zh_TW', N'WHUSA_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHUSAen_US', N'WHUSA', N'Wan Hai Lines (USA) LTD.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHUSAzh_TW', N'WHUSA', N'Wan Hai Lines (USA) LTD.', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHVN_tax_cbcr1_en_US', N'WHVN_tax_cbcr1', N'WAN HAI (VIETNAM) LTD.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHVN_tax_cbcr1_zh_TW', N'WHVN_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHVNen_US', N'WHVN', N'Wan Hai (Vietnam) Ltd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'WHVNzh_TW', N'WHVN', N'萬海航運(越南)有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'YIMY_tax_cbcr1_en_US', N'YIMY_tax_cbcr1', N'Yi Chun Shipping Agencies Sdn Bhd', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'YIMY_tax_cbcr1_zh_TW', N'YIMY_tax_cbcr1', NULL, N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'YIMYen_US', N'YIMY', N'Yi Chun Shipping Agencies Sdn. Bhd.', N'en_US', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime)),
    (N'YIMYzh_TW', N'YIMY', N'怡春船務代理(馬來西亞)有限公司', N'zh_TW', NULL, NULL, N'Workiva', CAST(N'2025-01-14T09:53:51.367' AS DateTime))
) AS source ([ID], [ENTITY_ID], [ENTITY_NAME], [LANGUAGE], [CREATED_BY], [CREATED_TIME], [UPDATED_BY], [UPDATED_TIME])
ON target.[ID] = source.[ID]
WHEN MATCHED THEN
    UPDATE SET 
        [ENTITY_ID] = source.[ENTITY_ID],
        [ENTITY_NAME] = source.[ENTITY_NAME],
        [LANGUAGE] = source.[LANGUAGE],
        [UPDATED_BY] = source.[UPDATED_BY],
        [UPDATED_TIME] = source.[UPDATED_TIME]
WHEN NOT MATCHED THEN
    INSERT ([ID], [ENTITY_ID], [ENTITY_NAME], [LANGUAGE], [CREATED_BY], [CREATED_TIME], [UPDATED_BY], [UPDATED_TIME])
    VALUES (source.[ID], source.[ENTITY_ID], source.[ENTITY_NAME], source.[LANGUAGE], 
            source.[CREATED_BY], source.[CREATED_TIME], source.[UPDATED_BY], source.[UPDATED_TIME]);