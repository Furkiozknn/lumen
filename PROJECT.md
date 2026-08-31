# Lumen

## Hedef
Godot 4'ün 2D ışık/gölge sistemini (Light2D, PointLight2D, LightOccluder2D) çekirdek
mekanik yapan minimalist bir 2D bulmaca oyunu. Oyuncu küçük, parlayan bir ışık
kaynağını karanlık bir odada yönetip çıkışa ulaştırıyor; gölge düşüren engeller
yolu şekillendiriyor.

## Kapsam disi
Bu ilk pass'te seviye ilerlemesi/menü yok, tek sahne var. İtilebilir bloklar,
gerçek piksel bazlı ışık örnekleme, ses, parçacık efektleri ve görsel cila
(vinyet, bloom, animasyonlu geçişler) kapsam dışı — sonraki iterasyonlara bırakıldı.

## Arac-stack
Godot 4.7 (GL Compatibility renderer), GDScript. Harici asset/paket yok;
ışık/glow dokuları sahne içinde GradientTexture2D olarak proceduraldir.

## Bitti tanimi
`scenes/main.tscn` headless modda script/parse hatası vermeden çalışıyor;
oyuncu WASD/ok tuşlarıyla hareket ediyor, en az 3 LightOccluder2D engeli gerçek
bir gölge bulmacası oluşturuyor, çıkış alanına yeterince aydınlık ulaşıldığında
kazanma durumu (print + renk değişimi) tetikleniyor.
