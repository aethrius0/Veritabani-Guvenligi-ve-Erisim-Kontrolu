-- ADIM 2: SQL Server Authentication ve Windows Authentication


USE WideWorldImporters;

-- =============================================
-- 1. SQL SERVER AUTHENTICATION ile LOGIN oluştur
-- (Kullanıcı adı ve şifre ile giriş)
-- =============================================
CREATE LOGIN SatisMusteri WITH PASSWORD = 'Satis123!';
CREATE LOGIN DepoPersonel WITH PASSWORD = 'Depo123!';
CREATE LOGIN MuhasebePersonel WITH PASSWORD = 'Muhasebe123!';

-- =============================================
-- 2. DATABASE KULLANICILARI oluştur
-- =============================================
CREATE USER SatisMusteri FOR LOGIN SatisMusteri;
CREATE USER DepoPersonel FOR LOGIN DepoPersonel;
CREATE USER MuhasebePersonel FOR LOGIN MuhasebePersonel;

-- =============================================
-- 3. MEVCUT AUTHENTICATION MODUNU KONTROL ET
-- =============================================
SELECT 
    SERVERPROPERTY('IsIntegratedSecurityOnly') AS SadecaWindowsAuth,
    CASE SERVERPROPERTY('IsIntegratedSecurityOnly')
        WHEN 1 THEN 'Sadece Windows Authentication'
        WHEN 0 THEN 'Mixed Mode (SQL Server + Windows)'
    END AS AuthModu;

-- =============================================
-- 4. OLUŞTURULAN LOGINLERİ KONTROL ET
-- =============================================
SELECT 
    name AS LoginAdi,
    type_desc AS LoginTipi,
    is_disabled AS DevreDisi,
    create_date AS OlusturmaTarihi
FROM sys.server_principals
WHERE name IN ('SatisMusteri', 'DepoPersonel', 'MuhasebePersonel')
ORDER BY name;

-- =============================================
-- 5. KULLANICILARA TEMEL YETKİLER VER
-- =============================================

-- SatisMusteri: Sadece Sales şemasını okuyabilir
GRANT SELECT ON SCHEMA::Sales TO SatisMusteri;

-- DepoPersonel: Warehouse şemasını okuyup yazabilir
GRANT SELECT, INSERT, UPDATE ON SCHEMA::Warehouse TO DepoPersonel;

-- MuhasebePersonel: Purchasing şemasını okuyabilir
GRANT SELECT ON SCHEMA::Purchasing TO MuhasebePersonel;

-- =============================================
-- 6. YETKİLERİ KONTROL ET
-- =============================================
SELECT 
    pr.name AS KullaniciAdi,
    pe.permission_name AS Yetki,
    pe.state_desc AS YetkiDurumu,
    ISNULL(o.name, pe.class_desc) AS Nesne
FROM sys.database_permissions pe
JOIN sys.database_principals pr ON pe.grantee_principal_id = pr.principal_id
LEFT JOIN sys.objects o ON pe.major_id = o.object_id
WHERE pr.name IN ('SatisMusteri', 'DepoPersonel', 'MuhasebePersonel')
ORDER BY pr.name;