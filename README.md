README.md dosyası oluştur ve içine yapıştır:
markdown# BLM4522 - Proje 3: Veritabanı Güvenliği ve Erişim Kontrolü

## Proje Hakkında
Bu proje, WideWorldImporters veritabanı üzerinde güvenlik 
tekniklerinin uygulanmasını kapsamaktadır.

## Kullanılan Teknolojiler
- Microsoft SQL Server 2025 Developer Edition
- SQL Server Management Studio (SSMS)
- WideWorldImporters örnek veritabanı

## Yapılan Çalışmalar

### Adım 1: Veritabanı Tanıma ve İlk Güvenlik Kontrolü
- Mevcut kullanıcılar, roller ve loginler listelendi
- Veritabanı şema yapısı incelendi

### Adım 2: SQL Server Authentication ve Windows Authentication
- SQL Server Authentication ile 3 yeni login oluşturuldu
  - SatisMusteri, DepoPersonel, MuhasebePersonel
- Windows Authentication modu kontrol edildi
- Her kullanıcıya şema bazlı yetkiler atandı

### Adım 3: Veri Şifreleme
- SQL Server Express TDE desteklemediğinden Developer Edition kuruldu
- Master Key ve Sertifika oluşturuldu
- AES_256 algoritması ile kolon bazlı şifreleme uygulandı
- Telefon ve Email kolonları şifrelenerek saklandı
- Şifreli ve çözülmüş veriler karşılaştırıldı

### Adım 4: SQL Injection Testleri ve Korunma
- Savunmasız dinamik sorgu ile injection saldırısı simüle edildi
- OR 1=1 saldırısı ile tüm kullanıcılar listelendi (açık gösterildi)
- Parametreli sorgu (sp_executesql) ile korunma sağlandı
- Stored Procedure ile korunma sağlandı
- Her iki korunma yönteminde saldırı sonuçsuz kaldı

### Adım 5: SQL Server Audit Logları
- Server Audit oluşturuldu (C:\AuditLogs\ klasörüne yazıyor)
- Database Audit Specification ile Sales şeması izlemeye alındı
- SELECT, INSERT, UPDATE, DELETE işlemleri loglandı
- Login Audit Specification ile giriş denemeleri izlendi
- Başarılı (LGIS) ve başarısız (LGIF) girişler loglandı

## Dosya Yapısı
├── adim1_ilk_kontrol.sql
├── adim2_authentication.sql
├── adim3_kolon_sifreleme.sql
├── adim4_sql_injection.sql
├── adim5_audit_log.sql
└── README.md

## Sonuçlar
- 3 farklı kullanıcı ve yetki seviyesi oluşturuldu
- AES_256 ile hassas veriler şifrelendi
- SQL Injection saldırısı simüle edildi ve 2 farklı korunma yöntemi gösterildi
- Audit logları ile kullanıcı aktiviteleri ve başarısız girişler izlendi
