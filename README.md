# Lumen

> **Durum: erken prototip, aktif geliştirilmiyor.** Bu depo tek oturumda
> yazılmış bir Godot 4 iskeletidir - bir seviye, temel ışık/gölge mekaniği,
> otomasyonsuz. Aktif projeler için profildeki öne çıkan depolara bakın;
> bu depo fikir arşivi olarak duruyor.

Karanlık bir odada küçük, parlayan bir ışık noktasını yönetip çıkışa ulaştırdığın
minimalist bir 2D ışık/gölge bulmacası. Godot 4'ün `Light2D` / `PointLight2D` /
`LightOccluder2D` sistemi üzerine kurulu.

## Kontroller
- Hareket: `WASD` veya ok tuşları
- Kamera oyuncuyu (ışığı) takip eder

## Bulmaca fikri
Oyuncunun taşıdığı `PointLight2D`, sahnedeki katı duvarlardan (`ObstacleA`,
`ObstacleB`) fiziksel olarak geçemez — bu duvarlar aynı zamanda gölge de
düşürür, yani odayı hem hareket hem ışık açısından şekillendirir. Üçüncü engel
(`ObstacleC`) ise sadece ışığı bloke eden, içinden geçilebilen bir "gölge
direği": oyuncu fiziksel olarak çıkışın yanına gelebilir ama ışığı çıkış
noktasına net ulaşmadıkça (yani direğin gölgesinde durmadıkça) kazanma
tetiklenmez. Çıkış, oyuncu tetikleyici alana girip *ve* çıkış noktasına
engelsiz bir ışık hattı (raycast ile yaklaşık olarak kontrol edilir) sağladığında
aktifleşir: konsola bir mesaj basar ve rengini yeşile çevirir.

## Durum: ilk pass / iskelet

Bu, oynanabilir bir dikey dilim (vertical slice) — bitmiş bir oyun değil.

**Güncelleme:** İlk sürüm sadece headless modda (script hatası kontrolü) test
edilmişti ve gerçekte ekranda neredeyse hiçbir şey görünmüyordu — `CanvasModulate`
sahneyi çok agresif karartıyordu ve `PointLight2D`'nin kendi texture-cookie
render'ı bu makinenin zorunlu kullandığı GL Compatibility renderer'da neredeyse
hiç görünür ışık üretmiyordu (bu, Compatibility renderer'a özgü bilinen bir
motor kısıtı — bkz. [godotengine/godot#90360](https://github.com/godotengine/godot/issues/90360)
ve ilişkili issue'lar). Godot'un kendi viewport'undan gerçek bir render
görüntüsü alıp (dosyaya kaydedip) inceleyerek bu ikisini de bulup düzelttim:
`CanvasModulate` nötrlendi, ve asıl görünür halenin kaynağı `PointLight2D`
yerine ayrı, additive-blend bir `Sprite2D` (`VisualGlow`) oldu —
`PointLight2D` artık asıl olarak gölge geometrisini (occluder etkileşimini)
sürüklüyor. Sonuç: sıcak, atmosferik bir ışık halesi ve duvarın attığı gerçek
bir gölge artık gerçekten görünüyor (render çıktısıyla doğrulandı).

Dürüst eksik listesi (hâlâ geçerli):
- Görsel render artık doğrulandı, ama **klavye ile gerçek bir interaktif
  oynanış turu** (Godot editöründe F5 basıp elle hareket ederek bulmacayı
  çözmek) hâlâ yapılmadı — sadece statik bir kare render edip incelendi.
  Hareket kodu (`player.gd`) mantıken doğru ama "hissi" doğrulanmadı.
- Işık halesinin tam rengi biraz sarı-amber'a kaçıyor, hedeflenen saf sıcak
  turuncudan az farklı — küçük bir ince ayar konusu, motor kısıtından değil.
- "Yeterince aydınlık" kontrolü gerçek piksel/ışık değeri örneklemiyor;
  raycast + mesafe eşiğiyle yaklaşık bir simülasyon. Çalışır ama tam ışık
  render'ıyla birebir aynı değil.
- Tek sahne, tek oda. Seviye ilerlemesi, itilebilir bloklar, ses efekti yok.
- `assets/` klasörü şimdilik boş — tüm görseller sahne içinde procedural.

## Klasör yapısı
```
lumen/
  project.godot
  scenes/main.tscn   # tek oynanabilir sahne
  scripts/
    player.gd        # hareket
    exit_zone.gd      # kazanma mantığı
  assets/            # şimdilik boş
```
