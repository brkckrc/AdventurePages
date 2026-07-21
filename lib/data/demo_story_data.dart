import '../models/character_reaction.dart';
import '../models/story_choice.dart';
import '../models/story_background_motion.dart';
import '../models/story_character_layer.dart';
import '../models/story_page.dart';

const String initialStoryPageId = 'front_yard_meeting';
const String candyChapterStartPageId = 'candy_land';
const String candyChapterEndPageId = 'candy_chapter_end';
const Set<String> demoChapterEndPageIds = {candyChapterEndPageId};

const String storyImagePath = 'assets/images/story';
const String introMeetingImage = '$storyImagePath/intro_01_meeting.png';
const String introBookFoundImage = '$storyImagePath/intro_02_book_found.png';
const String introBookGlowImage = '$storyImagePath/intro_03_book_glow.png';
const String introPortalImage = '$storyImagePath/intro_04_portal.png';
const String candyArrivalImage = '$storyImagePath/candy_01_arrival.png';
const String candyPofudukImage = '$storyImagePath/candy_02_pofuduk.png';
const String candyCaramelChaseImage =
    '$storyImagePath/candy_03_caramel_chase.png';
const String candyCastleShadowImage =
    '$storyImagePath/candy_04_castle_shadow.png';
const String candyVillageBackground =
    'assets/images/backgrounds/candy/candy_village_bg.png';
const String candyVillageBackgroundAlt01 =
    'assets/images/backgrounds/candy/candy_village_bg_alt_01.png';
const String candyVillageBackgroundAlt02 =
    'assets/images/backgrounds/candy/candy_village_bg_alt_02.png';
const String pofudukWaveImage =
    'assets/images/characters/pofuduk/pofuduk_wave.png';
const String pofudukBounceSound = 'assets/audio/sfx/pofuduk_bounce.wav';
const String boyIdleImage = 'assets/images/characters/boy/boy_idle.png';
const String boyThinkingImage = 'assets/images/characters/boy/boy_thinking.png';
const String boySurprisedImage =
    'assets/images/characters/boy/boy_surprised.png';
const String boyPointingImage = 'assets/images/characters/boy/boy_pointing.png';
const String girlIdleImage = 'assets/images/characters/girl/girl_idle.png';
const String girlThinkingImage =
    'assets/images/characters/girl/girl_thinking.png';
const String girlSurprisedImage =
    'assets/images/characters/girl/girl_surprised.png';
const String girlPointingImage =
    'assets/images/characters/girl/girl_pointing.png';

const Map<CharacterPose, String> boyCharacterPoseAssets = {
  CharacterPose.idle: boyIdleImage,
  CharacterPose.thinking: boyThinkingImage,
  CharacterPose.surprised: boySurprisedImage,
  CharacterPose.pointing: boyPointingImage,
};
const Map<CharacterPose, String> girlCharacterPoseAssets = {
  CharacterPose.idle: girlIdleImage,
  CharacterPose.thinking: girlThinkingImage,
  CharacterPose.surprised: girlSurprisedImage,
  CharacterPose.pointing: girlPointingImage,
};

const StoryCharacterLayer interactivePofudukLayer = StoryCharacterLayer(
  id: 'pofuduk',
  assetPath: pofudukWaveImage,
  x: 0.64,
  y: 0.16,
  width: 0.28,
  height: 0.66,
  idleAnimation: 'float_breathe',
  tapAnimation: 'squash_bounce',
  isInteractive: true,
  dialogueText: 'Pof! Hey, gıdıklanıyorum!',
  tapSoundEffect: pofudukBounceSound,
);

const Map<String, StoryPage> demoStoryPages = {
  'front_yard_meeting': StoryPage(
    id: 'front_yard_meeting',
    backgroundImage: introMeetingImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Evin Önünde Buluşma',
    titleCardText: 'ADVENTURE PAGES',
    showTitleCard: true,
    chapterId: 'intro',
    narrationText:
        '{{heroName}} ve {{friendName}} evin önünde buluştu. Gün batmadan önce yeni bir oyun bulmaya kararlıydılar. Büyük ağacın olduğu sokağa doğru koştular.',
    ambientSound: 'ambient_neighborhood',
    entrySoundEffect: 'door_chime',
    isCheckpoint: true,
    boyTapReactions: [
      CharacterReaction(
        text: 'Büyük ağaca kadar yarışalım!',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Bugün yeni bir şey bulacağız!',
        pose: CharacterPose.idle,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Önce etrafa dikkatlice bakalım.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Gün batmadan dönmeyi unutmayalım.',
        pose: CharacterPose.pointing,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'play_outside')],
  ),
  'play_outside': StoryPage(
    id: 'play_outside',
    backgroundImage: introMeetingImage,
    showHeroLayers: false,
    title: 'Mahallede Oyun',
    chapterId: 'intro',
    narrationText:
        'Büyük ağacın çevresinde saklambaç oynarken köklerin arasında metalik bir parıltı gördüler. {{friendName}} eğilip yaprakları araladı. Altından kalın, tozlu bir kapak çıktı.',
    ambientSound: 'ambient_neighborhood',
    boyDefaultPose: CharacterPose.thinking,
    girlDefaultPose: CharacterPose.thinking,
    boyTapReactions: [
      CharacterReaction(
        text: 'Köklerin altında bir şey parladı!',
        pose: CharacterPose.surprised,
      ),
      CharacterReaction(
        text: 'Bu, oyundan daha ilginç olabilir.',
        pose: CharacterPose.thinking,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Yaprakların altında bir kapak var.',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Önce tozunu dikkatlice silelim.',
        pose: CharacterPose.thinking,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'mysterious_book')],
  ),
  'mysterious_book': StoryPage(
    id: 'mysterious_book',
    backgroundImage: introBookFoundImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.panRight,
    title: 'Ağacın Altındaki Kitap',
    chapterId: 'intro',
    narrationText:
        'Kapak, kenarları yıpranmış eski bir kitaba aitti. Üzerindeki ince çizgiler şeker yolları gibi kıpırdayınca ikisi de bir adım geri çekildi. “Bu normal bir kitap değil,” dedi {{friendName}}.',
    ambientSound: 'ambient_neighborhood',
    boyDefaultPose: CharacterPose.thinking,
    girlDefaultPose: CharacterPose.thinking,
    boyTapReactions: [
      CharacterReaction(
        text: 'Bu kitap çok eski görünüyor.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Çizgiler gerçekten hareket etti!',
        pose: CharacterPose.surprised,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Kapağındaki işaretlere bak!',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Onu açmadan önce inceleyelim.',
        pose: CharacterPose.thinking,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'inspect_book')],
  ),
  'inspect_book': StoryPage(
    id: 'inspect_book',
    backgroundImage: introBookFoundImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Gizemli Kapak',
    chapterId: 'intro',
    narrationText:
        '{{heroName}} kitabı dikkatlice kaldırdı. Kapaktaki kale resmi bir an göz kırpar gibi parladı; sayfaların arasından tarçınlı şeker kokusu geldi. İkisi şaşkınlıkla birbirine baktı.',
    ambientSound: 'ambient_neighborhood',
    entrySoundEffect: 'page_rustle',
    boyDefaultPose: CharacterPose.thinking,
    girlDefaultPose: CharacterPose.thinking,
    boyTapReactions: [
      CharacterReaction(
        text: 'İçinden şeker kokusu geliyor.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Kale resmi az önce parladı!',
        pose: CharacterPose.surprised,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Bu işaretler bir yol haritası olabilir.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Sayfalar sanki bizi bekliyor.',
        pose: CharacterPose.surprised,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'book_glows')],
  ),
  'book_glows': StoryPage(
    id: 'book_glows',
    backgroundImage: introBookGlowImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Parlayan Sayfalar',
    chapterId: 'intro',
    narrationText:
        'İlk sayfa açılır açılmaz altın renkli harfler havaya yükseldi. Çizimler kıpırdadı, kitabın içinden sıcak bir ışık taştı. {{heroName}} kitabı kapatmaya çalıştı ama sayfalar kendi kendine çevriliyordu.',
    ambientSound: 'ambient_magic',
    entrySoundEffect: 'magic_glow',
    boyDefaultPose: CharacterPose.surprised,
    girlDefaultPose: CharacterPose.surprised,
    boyTapReactions: [
      CharacterReaction(
        text: 'Kitap gerçekten parlıyor!',
        pose: CharacterPose.surprised,
      ),
      CharacterReaction(
        text: 'Harfler havada yüzüyor!',
        pose: CharacterPose.pointing,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Sanırım bize bir şey göstermek istiyor.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Işık gittikçe güçleniyor.',
        pose: CharacterPose.surprised,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'portal_opens')],
  ),
  'portal_opens': StoryPage(
    id: 'portal_opens',
    backgroundImage: introPortalImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Açılan Portal',
    chapterId: 'intro',
    narrationText:
        'Işık, kitabın üzerinde dönen rengarenk bir geçide dönüştü. Rüzgâr yaprakları ve kâğıtları çevrelerinde savurdu. “Biraz geri çekilelim!” diye seslendi {{friendName}}.',
    ambientSound: 'ambient_magic',
    entrySoundEffect: 'page_portal',
    boyDefaultPose: CharacterPose.surprised,
    girlDefaultPose: CharacterPose.surprised,
    boyTapReactions: [
      CharacterReaction(text: 'Hazır mısın?', pose: CharacterPose.pointing),
      CharacterReaction(
        text: 'Bu geçit nereye açılıyor?',
        pose: CharacterPose.thinking,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Birlikte gidersek korkmam.',
        pose: CharacterPose.idle,
      ),
      CharacterReaction(
        text: 'Rüzgâr bizi kendine çekiyor!',
        pose: CharacterPose.surprised,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'pulled_inside')],
  ),
  'pulled_inside': StoryPage(
    id: 'pulled_inside',
    backgroundImage: introPortalImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Kitabın İçine',
    chapterId: 'intro',
    narrationText:
        'Ama geçit çoktan onları çekmeye başlamıştı. {{heroName}} ile {{friendName}} el ele verdi; ayakları yerden kesilirken birbirlerini bırakmadılar. Bir sayfa hışırtısıyla ağacın altından kayboldular.',
    ambientSound: 'ambient_magic',
    boyDefaultPose: CharacterPose.surprised,
    girlDefaultPose: CharacterPose.surprised,
    boyTapReactions: [
      CharacterReaction(
        text: 'Elimi sakın bırakma!',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Kitabın içine giriyoruz!',
        pose: CharacterPose.surprised,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Birbirimize tutunalım!',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Ayaklarım yerden kesildi!',
        pose: CharacterPose.surprised,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'candy_land')],
  ),
  'candy_land': StoryPage(
    id: 'candy_land',
    backgroundImage: candyVillageBackgroundAlt01,
    fallbackBackgroundImage: candyArrivalImage,
    backgroundMotion: StoryBackgroundMotion.slowZoomOut,
    title: 'Şeker Diyarı',
    titleCardText: 'ŞEKER DİYARI',
    showTitleCard: true,
    chapterId: 'candy_land',
    narrationText:
        '{{heroName}} ve {{friendName}} yumuşacık bir tepeye düşüp birkaç kez zıpladı. Çevrelerinde şekerden evler, gökkuşağı renkli yollar ve dumanı vanilya kokan bacalar vardı. Yakındaki bir lolipop çiçeği, onlar bakınca yapraklarını utangaçça kapattı.',
    ambientSound: 'ambient_candy_land',
    entrySoundEffect: 'soft_chime',
    isCheckpoint: true,
    boyDefaultPose: CharacterPose.surprised,
    girlDefaultPose: CharacterPose.surprised,
    boyTapReactions: [
      CharacterReaction(
        text: 'Burası gerçekten şekerden mi yapılmış?',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Şu tepe zıplıyor!',
        pose: CharacterPose.surprised,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Her yer rengârenk!',
        pose: CharacterPose.surprised,
      ),
      CharacterReaction(
        text: 'Lolipop çiçeği bizi gördü.',
        pose: CharacterPose.pointing,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'candy_orientation')],
  ),
  'candy_orientation': StoryPage(
    id: 'candy_orientation',
    backgroundImage: candyVillageBackgroundAlt01,
    fallbackBackgroundImage: candyArrivalImage,
    title: 'Burası Neresi?',
    chapterId: 'candy_land',
    narrationText:
        '{{friendName}} havayı kokladı; çilek, karamela ve sıcak kurabiye kokuları birbirine karışıyordu. Uzakta bir çan çaldı ama renkli sokaklarda kimse görünmüyordu. “Burası harika… ama neden bu kadar sessiz?” diye fısıldadı {{heroName}}.',
    ambientSound: 'ambient_candy_land',
    boyDefaultPose: CharacterPose.thinking,
    girlDefaultPose: CharacterPose.thinking,
    boyTapReactions: [
      CharacterReaction(
        text: 'Şu evin çatısı bisküvi!',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Bu sessizlik biraz tuhaf.',
        pose: CharacterPose.thinking,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Vanilya kokusu o bacadan geliyor.',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Sokaklarda neden kimse yok?',
        pose: CharacterPose.thinking,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'candy_village')],
  ),
  'candy_village': StoryPage(
    id: 'candy_village',
    backgroundImage: candyVillageBackground,
    fallbackBackgroundImage: candyArrivalImage,
    backgroundMotion: StoryBackgroundMotion.panLeft,
    title: 'Şeker Köyü',
    chapterId: 'candy_land',
    narrationText:
        'Renkli taşlı yolu izleyip küçük köye girdiler. Bazı evlerin şeker kaplaması solmuş, bisküvi tabelaları yana eğilmişti. Tam kapısı açık bir dükkâna yaklaşırken çalılıktan telaşlı bir “Durun!” sesi geldi.',
    ambientSound: 'ambient_candy_land',
    boyDefaultPose: CharacterPose.thinking,
    girlDefaultPose: CharacterPose.thinking,
    boyTapReactions: [
      CharacterReaction(
        text: 'Açık dükkâna bakalım mı?',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Az önce çalılıktan ses geldi!',
        pose: CharacterPose.surprised,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Evlerin renkleri solmuş.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Biri bize “durun” dedi.',
        pose: CharacterPose.surprised,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'pofuduk_meeting')],
  ),
  'pofuduk_meeting': StoryPage(
    id: 'pofuduk_meeting',
    backgroundImage: candyVillageBackground,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    fallbackBackgroundImage: candyPofudukImage,
    title: 'Pofuduk ile Karşılaşma',
    chapterId: 'candy_land',
    narrationText:
        'Çalılıktan yuvarlak, yumuşacık bir canlı fırladı; durmak isterken iki kez zıplayıp çocukların önüne oturdu. “Oh, yakaladım sizi! Ben Pofuduk,” dedi nefes nefese gülümseyerek. “Şeker Diyarı’na hoş geldiniz… sanırım.”',
    ambientSound: 'ambient_candy_land',
    isCheckpoint: true,
    boyDefaultPose: CharacterPose.surprised,
    girlDefaultPose: CharacterPose.surprised,
    boyTapReactions: [
      CharacterReaction(
        text: 'Pofuduk yolu biliyor olabilir.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'İki kez zıplayarak durdu!',
        pose: CharacterPose.surprised,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Önce onu dinleyelim.',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Pofuduk biraz telaşlı görünüyor.',
        pose: CharacterPose.thinking,
      ),
    ],
    characterLayers: [interactivePofudukLayer],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'pofuduk_explains')],
  ),
  'pofuduk_explains': StoryPage(
    id: 'pofuduk_explains',
    backgroundImage: candyVillageBackground,
    fallbackBackgroundImage: candyPofudukImage,
    title: 'Pofuduk\'un Haberi',
    chapterId: 'candy_land',
    narrationText:
        'Pofuduk’un gülümsemesi biraz küçüldü. “Burası eskiden şarkılarla doluydu; Bay Bayat yaklaştıkça renkler ve tatlar soluyor,” dedi. Kaleyi gösterip ekledi: “Onu durdurmanın yolu Şeker Kalesi’nde, ama yollar artık pek uslu değil.”',
    ambientSound: 'ambient_candy_land',
    boyDefaultPose: CharacterPose.thinking,
    girlDefaultPose: CharacterPose.thinking,
    boyTapReactions: [
      CharacterReaction(
        text: 'Bay Bayat renkleri nasıl solduruyor?',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Kaleye hemen gitmeliyiz.',
        pose: CharacterPose.pointing,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Güvenli bir yol seçmeliyiz.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Pofuduk kaleye giden yolu biliyor.',
        pose: CharacterPose.pointing,
      ),
    ],
    characterLayers: [interactivePofudukLayer],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'first_candy_choice')],
  ),
  'first_candy_choice': StoryPage(
    id: 'first_candy_choice',
    backgroundImage: candyVillageBackgroundAlt02,
    fallbackBackgroundImage: candyPofudukImage,
    title: 'İlk Karar',
    chapterId: 'candy_land',
    narrationText:
        'Önlerinde iki yol ayrıldı. Soldaki karamel köprüsü kaleye daha çabuk ulaşıyordu ama her adımda esniyordu. Sağdaki şeker ağaçları güvenli görünüyordu, fakat tepenin çevresinden dolanıyordu.',
    ambientSound: 'ambient_candy_land',
    boyDefaultPose: CharacterPose.thinking,
    girlDefaultPose: CharacterPose.thinking,
    boyTapReactions: [
      CharacterReaction(
        text: 'Köprü hızlı görünüyor.',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Kestirmeyi deneyebiliriz!',
        pose: CharacterPose.idle,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Ağaçların yolu daha güvenli.',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Önce zemini kontrol edelim.',
        pose: CharacterPose.thinking,
      ),
    ],
    characterLayers: [interactivePofudukLayer],
    choices: [
      StoryChoice(
        text: 'Karamel köprüsünden geç',
        nextPageId: 'follow_pofuduk',
      ),
      StoryChoice(text: 'Şeker ağaçlarından dolaş', nextPageId: 'look_around'),
    ],
  ),
  'follow_pofuduk': StoryPage(
    id: 'follow_pofuduk',
    backgroundImage: candyVillageBackground,
    fallbackBackgroundImage: candyPofudukImage,
    title: 'Karamel Köprüsü',
    chapterId: 'candy_land',
    narrationText:
        '“Peşimden gelin; hızlı ama dikkatli!” diyen Pofuduk köprüye atladı. {{heroName}} ilk adıma basınca karamel sakız gibi uzayıp yeniden toplandı. Üçü, ayakkabıları hafifçe yapışarak karşı kıyıya ulaştı.',
    ambientSound: 'ambient_candy_land',
    boyTapReactions: [
      CharacterReaction(
        text: 'Köprü sandığımdan daha yapışkan!',
        pose: CharacterPose.surprised,
      ),
      CharacterReaction(
        text: 'Hızlı adımlarla geçelim!',
        pose: CharacterPose.pointing,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Aynı yerlere basarsak geçeriz.',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Dengeyi kaybetmeyelim.',
        pose: CharacterPose.thinking,
      ),
    ],
    characterLayers: [interactivePofudukLayer],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'caramel_warning')],
  ),
  'look_around': StoryPage(
    id: 'look_around',
    backgroundImage: candyVillageBackgroundAlt01,
    fallbackBackgroundImage: candyArrivalImage,
    backgroundMotion: StoryBackgroundMotion.panLeft,
    title: 'Şeker Ağaçları',
    chapterId: 'candy_land',
    narrationText:
        'Şeker ağaçlarının arasındaki yol daha uzundu ama zemin sağlamdı. {{friendName}}, solmuş yapraklarda aynı yöne uzanan karamel izlerini fark etti. İzler onları Pofuduk’un beklediği yol ayrımına çıkardı.',
    ambientSound: 'ambient_candy_land',
    boyDefaultPose: CharacterPose.thinking,
    girlDefaultPose: CharacterPose.thinking,
    boyTapReactions: [
      CharacterReaction(
        text: 'Bu yol uzun ama sakin.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Karamel izleri şuraya gidiyor!',
        pose: CharacterPose.pointing,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Solmuş yapraklar bir iz bırakmış.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'İzleri takip edersek kaybolmayız.',
        pose: CharacterPose.pointing,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'caramel_warning')],
  ),
  'caramel_warning': StoryPage(
    id: 'caramel_warning',
    backgroundImage: candyCaramelChaseImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.panRight,
    title: 'Karamel Tehlikesi',
    chapterId: 'candy_land',
    narrationText:
        'İki yol, fokurdamaya başlayan geniş bir karamel deresinin önünde birleşti. Dalgalar şeker taşlarını birer birer yutuyordu. Pofuduk sağlam taşları gösterdi; karşıdaki parlak kestirme ise çok yakın görünüyordu.',
    ambientSound: 'ambient_candy_land',
    entrySoundEffect: 'caramel_roll',
    isCheckpoint: true,
    boyDefaultPose: CharacterPose.surprised,
    girlDefaultPose: CharacterPose.thinking,
    boyTapReactions: [
      CharacterReaction(
        text: 'Taşların üstünden koşabiliriz!',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Kestirme çok yakın görünüyor.',
        pose: CharacterPose.thinking,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Fokurdayan karamele basmayalım.',
        pose: CharacterPose.surprised,
      ),
      CharacterReaction(
        text: 'Sağlam taşları sırayla izleyelim.',
        pose: CharacterPose.pointing,
      ),
    ],
    choices: [
      StoryChoice(text: 'Sağlam taşlardan koş', nextPageId: 'caramel_chase'),
      StoryChoice(text: 'Parlak kestirmeye atla', nextPageId: 'caramel_trap'),
    ],
  ),
  'caramel_trap': StoryPage(
    id: 'caramel_trap',
    backgroundImage: candyCaramelChaseImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.panRight,
    title: 'Yapışkan Kestirme',
    chapterId: 'candy_land',
    narrationText:
        '{{heroName}} parlak zemine basar basmaz ayakkabıları karamele gömüldü. {{friendName}} yakındaki şeker dalına tutunup onu bütün gücüyle çekti; Pofuduk da arkadan itti. Kurtuldular ama kestirme kapanmıştı. Üçü kendi ayak izlerini izleyerek güvenli taşların başına döndü.',
    ambientSound: 'ambient_candy_land',
    boyDefaultPose: CharacterPose.surprised,
    girlDefaultPose: CharacterPose.surprised,
    boyTapReactions: [
      CharacterReaction(
        text: 'Ayakkabılarım yapıştı!',
        pose: CharacterPose.surprised,
      ),
      CharacterReaction(
        text: 'Bu kestirme iyi fikir değilmiş.',
        pose: CharacterPose.thinking,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Şeker dalına tutun!',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Ayak izlerimiz geri yolu gösteriyor.',
        pose: CharacterPose.thinking,
      ),
    ],
    choices: [
      StoryChoice(
        text: 'Ayak izlerini takip edip dön',
        nextPageId: 'caramel_warning',
      ),
    ],
  ),
  'caramel_chase': StoryPage(
    id: 'caramel_chase',
    backgroundImage: candyCaramelChaseImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.panRight,
    title: 'Karamel Kovalamacası',
    chapterId: 'candy_land',
    narrationText:
        'Bu kez sağlam taşlara birlikte bastılar. Son taşa yaklaşınca arkalarındaki karamel kabarıp yuvarlanan bir dalgaya dönüştü. “Tepeye!” diye bağırdı Pofuduk.',
    ambientSound: 'ambient_candy_land',
    boyDefaultPose: CharacterPose.surprised,
    girlDefaultPose: CharacterPose.surprised,
    boyTapReactions: [
      CharacterReaction(
        text: 'Karamel çok hızlı!',
        pose: CharacterPose.surprised,
      ),
      CharacterReaction(text: 'Tepeye koşalım!', pose: CharacterPose.pointing),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Dalgayı gözden kaçırmayalım!',
        pose: CharacterPose.surprised,
      ),
      CharacterReaction(
        text: 'Aynı taşlara basın!',
        pose: CharacterPose.pointing,
      ),
    ],
    choices: [
      StoryChoice(text: 'Birlikte tepeye koş', nextPageId: 'help_each_other'),
    ],
  ),
  'help_each_other': StoryPage(
    id: 'help_each_other',
    backgroundImage: candyCaramelChaseImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.panRight,
    title: 'Birlikte Daha Güçlü',
    chapterId: 'candy_land',
    narrationText:
        '{{heroName}} öndeki şeker dalına ulaşıp elini uzattı. {{friendName}} o eli son anda yakaladı; Pofuduk da ikisini birden ileri itti. Karamel dalgası ayaklarının dibinde durup köpüklü bir lokuma dönüştü.',
    ambientSound: 'ambient_candy_land',
    boyDefaultPose: CharacterPose.pointing,
    girlDefaultPose: CharacterPose.pointing,
    boyTapReactions: [
      CharacterReaction(
        text: 'Elimi tut, seni çekerim!',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Birlikte başarabiliriz!',
        pose: CharacterPose.idle,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Pofuduk, arkadan it!',
        pose: CharacterPose.pointing,
      ),
      CharacterReaction(
        text: 'Şeker dalı bizi taşıyacak.',
        pose: CharacterPose.thinking,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'paths_rejoin')],
  ),
  'paths_rejoin': StoryPage(
    id: 'paths_rejoin',
    backgroundImage: candyVillageBackgroundAlt02,
    fallbackBackgroundImage: candyCaramelChaseImage,
    title: 'Yollar Birleşiyor',
    chapterId: 'candy_land',
    narrationText:
        'Bir süre nefeslerini toparladılar. Pofuduk, “Fena değildi… yalnız dönüşte başka yol bulsak iyi olur,” dedi. Solmuş şeker ağaçlarının arasından tepenin son basamaklarına çıktılar.',
    ambientSound: 'ambient_candy_land',
    boyTapReactions: [
      CharacterReaction(
        text: 'Dönüşte köprüyü seçmeyelim.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Kale şu tepenin ardında!',
        pose: CharacterPose.pointing,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Önce biraz nefeslenelim.',
        pose: CharacterPose.idle,
      ),
      CharacterReaction(
        text: 'Solmuş ağaçlar kaleye uzanıyor.',
        pose: CharacterPose.pointing,
      ),
    ],
    characterLayers: [interactivePofudukLayer],
    choices: [
      StoryChoice(text: 'Tepenin zirvesine çık', nextPageId: 'castle_view'),
    ],
  ),
  'castle_view': StoryPage(
    id: 'castle_view',
    backgroundImage: candyVillageBackgroundAlt02,
    fallbackBackgroundImage: candyCastleShadowImage,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Şeker Kalesi',
    titleCardText: 'ŞEKER KALESİ',
    showTitleCard: true,
    chapterId: 'candy_land',
    narrationText:
        'Zirveye vardıklarında Şeker Kalesi bütün görkemiyle karşılarında yükseldi. Kuleleri kristal şeker gibi parlıyordu, fakat renkler duvarların üzerinden yavaşça çekiliyordu. En yüksek kulenin ardında uzun, gri bir gölge kıpırdadı.',
    ambientSound: 'ambient_castle',
    isCheckpoint: true,
    boyDefaultPose: CharacterPose.surprised,
    girlDefaultPose: CharacterPose.surprised,
    boyTapReactions: [
      CharacterReaction(
        text: 'Kale düşündüğümden çok büyük!',
        pose: CharacterPose.surprised,
      ),
      CharacterReaction(
        text: 'En yüksek kuleye bak!',
        pose: CharacterPose.pointing,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Renkler duvarlardan çekiliyor.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Gölge kulenin arkasında kıpırdadı.',
        pose: CharacterPose.pointing,
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'bay_bayat_shadow')],
  ),
  'bay_bayat_shadow': StoryPage(
    id: 'bay_bayat_shadow',
    backgroundImage: candyCastleShadowImage,
    showHeroLayers: false,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Bay Bayat\'ın Gölgesi',
    chapterId: 'candy_land',
    narrationText:
        'Bir çan, rüzgâr olmadan kendi kendine çaldı. Gölge kalenin duvarlarına yayıldı; şeker süsler bir anlığına soldu. Pofuduk, “Bay Bayat bizi fark etti. Bundan sonra birbirimizden ayrılmayalım,” diye fısıldadı. {{heroName}} ile {{friendName}} kaleye doğru ilk adımı birlikte attı.',
    ambientSound: 'ambient_castle',
    boyDefaultPose: CharacterPose.thinking,
    girlDefaultPose: CharacterPose.thinking,
    boyTapReactions: [
      CharacterReaction(
        text: 'Kalede biri olabilir.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Birlikte ilerleyelim.',
        pose: CharacterPose.pointing,
      ),
    ],
    girlTapReactions: [
      CharacterReaction(
        text: 'Biraz sessiz ilerleyelim.',
        pose: CharacterPose.thinking,
      ),
      CharacterReaction(
        text: 'Gölge bizi fark etmiş olabilir.',
        pose: CharacterPose.surprised,
      ),
    ],
    choices: [
      StoryChoice(
        text: 'Kaleye doğru ilerle',
        nextPageId: candyChapterEndPageId,
      ),
    ],
  ),
};
