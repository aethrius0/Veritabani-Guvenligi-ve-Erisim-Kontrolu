-- ADIM 4: SQL Injection Testleri ve Korunma
-- BLM4522 - Proje 3: Veritabanı Güvenliği ve Erişim Kontrolü

USE WideWorldImporters;

-- =============================================
-- 1. TEST İÇİN TABLO OLUŞTUR
-- =============================================
CREATE TABLE Kullanici_Giris (
    KullaniciID INT PRIMARY KEY IDENTITY,
    KullaniciAdi VARCHAR(50),
    Sifre VARCHAR(50)
);

INSERT INTO Kullanici_Giris (KullaniciAdi, Sifre)
VALUES 
    ('admin', 'Admin123!'),
    ('ahmet', 'Ahmet123!'),
    ('ayse', 'Ayse123!');

-- =============================================
-- 2. NORMAL GİRİŞ (doğru kullanıcı adı ve şifre)
-- =============================================
DECLARE @SorguNormal NVARCHAR(500);
SET @SorguNormal = 'SELECT * FROM Kullanici_Giris WHERE KullaniciAdi = ''admin'' AND Sifre = ''Admin123!''';

PRINT 'Normal Sorgu: ' + @SorguNormal;
EXEC(@SorguNormal);
-- Sadece admin gelecek (doğru)

-- =============================================
-- 3. SQL INJECTION SALDIRISI
-- =============================================
-- Saldırgan şifreyi bilmeden tüm kullanıcılara erişiyor!
DECLARE @SorguSaldiri NVARCHAR(500);
SET @SorguSaldiri = 'SELECT * FROM Kullanici_Giris WHERE KullaniciAdi = ''x'' OR 1=1--''';

PRINT 'Saldiri Sorgusu: ' + @SorguSaldiri;
EXEC(@SorguSaldiri);
-- Tüm kullanıcılar listelenecek! (güvenlik açığı)

-- =============================================
-- 4. KORUNMA 1: Parametreli Sorgu
-- =============================================
DECLARE @GuvenliSorgu NVARCHAR(500);
SET @GuvenliSorgu = N'SELECT * FROM Kullanici_Giris 
    WHERE KullaniciAdi = @KAdi AND Sifre = @KSifre';

EXEC sp_executesql @GuvenliSorgu,
    N'@KAdi VARCHAR(50), @KSifre VARCHAR(50)',
    @KAdi = 'x'' OR 1=1--',
    @KSifre = 'yanlis_sifre';
-- Sonuç boş gelecek! (güvenli)

-- =============================================
-- 5. KORUNMA 2: Stored Procedure Oluştur
-- =============================================
GO
CREATE PROCEDURE sp_GuvenliGiris
    @KullaniciAdi VARCHAR(50),
    @Sifre VARCHAR(50)
AS
BEGIN
    SELECT * FROM Kullanici_Giris
    WHERE KullaniciAdi = @KullaniciAdi 
    AND Sifre = @Sifre;
END;
GO

-- Stored Procedure ile saldırıyı dene
EXEC sp_GuvenliGiris 
    @KullaniciAdi = 'x'' OR 1=1--', 
    @Sifre = 'yanlis_sifre';
-- Sonuç boş gelecek! (güvenli)