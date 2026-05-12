-- ADIM 1: Veritabanı Tanıma ve İlk Güvenlik Kontrolü


USE WideWorldImporters;

-- 1. Veritabanındaki tabloları gör
SELECT 
    TABLE_SCHEMA AS Sema,
    TABLE_NAME AS TabloAdi,
    TABLE_TYPE AS Tip
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- 2. Mevcut kullanıcıları listele
SELECT 
    name AS KullaniciAdi,
    type_desc AS KullaniciTipi,
    create_date AS OlusturmaTarihi
FROM sys.database_principals
WHERE type IN ('S', 'U', 'G')
ORDER BY name;

-- 3. Mevcut rolleri listele
SELECT 
    name AS RolAdi,
    type_desc AS RolTipi
FROM sys.database_principals
WHERE type = 'R'
ORDER BY name;

-- 4. Sunucu seviyesindeki loginleri listele
SELECT 
    name AS LoginAdi,
    type_desc AS LoginTipi,
    is_disabled AS DevreDisi,
    create_date AS OlusturmaTarihi
FROM sys.server_principals
WHERE type IN ('S', 'U')
ORDER BY name;