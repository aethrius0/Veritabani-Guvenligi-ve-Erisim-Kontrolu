-- ADIM 3: Kolon Bazlı Şifreleme

-- NOT: SQL Server Express TDE desteklemediğinden kolon şifreleme uygulandı

USE WideWorldImporters;

-- =============================================
-- 1. MASTER KEY OLUŞTUR
-- =============================================
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MasterKey123!';

-- =============================================
-- 2. SERTİFİKA OLUŞTUR
-- =============================================
CREATE CERTIFICATE Kolon_Sertifika
WITH SUBJECT = 'Kolon Sifreleme Sertifikasi';

-- =============================================
-- 3. SİMETRİK ANAHTAR OLUŞTUR
-- =============================================
CREATE SYMMETRIC KEY Kolon_Anahtar
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE Kolon_Sertifika;

-- =============================================
-- 4. ŞİFRELENECEK KOLON İÇİN TABLO OLUŞTUR
-- =============================================
CREATE TABLE Gizli_Musteri_Bilgi (
    MusteriID INT PRIMARY KEY IDENTITY,
    MusteriAdi NVARCHAR(100),
    TelefonSifreli VARBINARY(256),
    EmailSifreli VARBINARY(256)
);

-- =============================================
-- 5. VERİ EKLE (şifreleyerek)
-- =============================================
OPEN SYMMETRIC KEY Kolon_Anahtar
DECRYPTION BY CERTIFICATE Kolon_Sertifika;

INSERT INTO Gizli_Musteri_Bilgi (MusteriAdi, TelefonSifreli, EmailSifreli)
VALUES 
    ('Ahmet Yilmaz', 
     ENCRYPTBYKEY(KEY_GUID('Kolon_Anahtar'), '05321234567'),
     ENCRYPTBYKEY(KEY_GUID('Kolon_Anahtar'), 'ahmet@email.com')),
    ('Ayse Kaya', 
     ENCRYPTBYKEY(KEY_GUID('Kolon_Anahtar'), '05329876543'),
     ENCRYPTBYKEY(KEY_GUID('Kolon_Anahtar'), 'ayse@email.com')),
    ('Mehmet Demir', 
     ENCRYPTBYKEY(KEY_GUID('Kolon_Anahtar'), '05331112233'),
     ENCRYPTBYKEY(KEY_GUID('Kolon_Anahtar'), 'mehmet@email.com'));

CLOSE SYMMETRIC KEY Kolon_Anahtar;

-- =============================================
-- 6. ŞİFRELİ VERİYİ GÖR (ham hali)
-- =============================================
SELECT 
    MusteriID,
    MusteriAdi,
    TelefonSifreli,
    EmailSifreli
FROM Gizli_Musteri_Bilgi;

-- =============================================
-- 7. VERİYİ ŞİFRE ÇÖZEREK GÖR
-- =============================================
OPEN SYMMETRIC KEY Kolon_Anahtar
DECRYPTION BY CERTIFICATE Kolon_Sertifika;

SELECT 
    MusteriID,
    MusteriAdi,
    CAST(DECRYPTBYKEY(TelefonSifreli) AS VARCHAR(50)) AS Telefon,
    CAST(DECRYPTBYKEY(EmailSifreli) AS VARCHAR(50)) AS Email
FROM Gizli_Musteri_Bilgi;

CLOSE SYMMETRIC KEY Kolon_Anahtar;