-- ADIM 5: SQL Server Audit Logları


USE master;

-- =============================================
-- 1. SERVER AUDIT OLUŞTUR
-- =============================================
CREATE SERVER AUDIT WideWorld_Audit
TO FILE 
(
    FILEPATH = 'C:\AuditLogs\',
    MAXSIZE = 10 MB,
    MAX_ROLLOVER_FILES = 5,
    RESERVE_DISK_SPACE = OFF
)
WITH
(
    QUEUE_DELAY = 1000,
    ON_FAILURE = CONTINUE
);

-- Audit'i aktif et
ALTER SERVER AUDIT WideWorld_Audit WITH (STATE = ON);

-- =============================================
-- 2. DATABASE AUDIT SPECIFICATION OLUŞTUR
-- =============================================
USE WideWorldImporters;

CREATE DATABASE AUDIT SPECIFICATION WideWorld_DB_Audit
FOR SERVER AUDIT WideWorld_Audit
ADD (SELECT ON SCHEMA::Sales BY PUBLIC),
ADD (INSERT ON SCHEMA::Sales BY PUBLIC),
ADD (UPDATE ON SCHEMA::Sales BY PUBLIC),
ADD (DELETE ON SCHEMA::Sales BY PUBLIC);

-- Database Audit'i aktif et
ALTER DATABASE AUDIT SPECIFICATION WideWorld_DB_Audit
WITH (STATE = ON);

-- =============================================
-- 3. AUDIT'İ TEST ET (bazı işlemler yap)
-- =============================================
USE WideWorldImporters;

SELECT TOP 10 * FROM Sales.Orders;
SELECT TOP 10 * FROM Sales.Customers;
SELECT TOP 10 * FROM Sales.Invoices;

-- =============================================
-- 4. AUDIT LOGLARINI OKU
-- =============================================
USE master;

SELECT TOP 20
    event_time AS IslemZamani,
    action_id AS IslemTipi,
    server_principal_name AS KullaniciAdi,
    database_name AS VeritabaniAdi,
    object_name AS NesneAdi,
    statement AS Sorgu,
    succeeded AS Basarili
FROM sys.fn_get_audit_file('C:\AuditLogs\*', DEFAULT, DEFAULT)
ORDER BY event_time DESC;

-- =============================================
-- 5. BAŞARISIZ GİRİŞ DENEMELERİNİ İZLE
-- =============================================
CREATE SERVER AUDIT SPECIFICATION WideWorld_Login_Audit
FOR SERVER AUDIT WideWorld_Audit
ADD (FAILED_LOGIN_GROUP),
ADD (SUCCESSFUL_LOGIN_GROUP);

ALTER SERVER AUDIT SPECIFICATION WideWorld_Login_Audit
WITH (STATE = ON);

-- Giriş loglarını gör
SELECT TOP 20
    event_time AS GirisTarihi,
    action_id AS IslemTipi,
    server_principal_name AS KullaniciAdi,
    succeeded AS Basarili
FROM sys.fn_get_audit_file('C:\AuditLogs\*', DEFAULT, DEFAULT)
WHERE action_id IN ('LGIS', 'LGIF', 'LGLO')
ORDER BY event_time DESC;