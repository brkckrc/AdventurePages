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
const String pofudukWaveImage =
    'assets/images/characters/pofuduk/pofuduk_wave.png';
const String pofudukBounceSound = 'assets/audio/sfx/pofuduk_bounce.wav';

const Map<String, StoryPage> demoStoryPages = {
  'front_yard_meeting': StoryPage(
    id: 'front_yard_meeting',
    backgroundImage: introMeetingImage,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Evin Önünde Buluşma',
    titleCardText: 'ADVENTURE PAGES',
    showTitleCard: true,
    chapterId: 'intro',
    narrationText:
        '{{heroName}} ve {{friendName}} güneş yavaşça alçalırken evin önünde buluştu. Bugün sıradan bir oyun günü gibi görünüyordu.',
    ambientSound: 'ambient_neighborhood',
    entrySoundEffect: 'door_chime',
    isCheckpoint: true,
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'play_outside')],
  ),
  'play_outside': StoryPage(
    id: 'play_outside',
    backgroundImage: introMeetingImage,
    title: 'Mahallede Oyun',
    chapterId: 'intro',
    narrationText:
        '{{heroName}} ile {{friendName}} kaldırım taşlarının üstünden zıplayıp saklambaç oynadı. Rüzgar, büyük ağacın yapraklarını usulca hışırdatıyordu.',
    ambientSound: 'ambient_neighborhood',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'mysterious_book')],
  ),
  'mysterious_book': StoryPage(
    id: 'mysterious_book',
    backgroundImage: introBookFoundImage,
    backgroundMotion: StoryBackgroundMotion.panRight,
    title: 'Ağacın Altındaki Kitap',
    chapterId: 'intro',
    narrationText:
        'Ağacın kökleri arasında, yaprakların altından altın renkli bir köşe parladı. {{friendName}}, bunun eski bir kitap olduğunu fark etti.',
    ambientSound: 'ambient_neighborhood',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'inspect_book')],
  ),
  'inspect_book': StoryPage(
    id: 'inspect_book',
    backgroundImage: introBookFoundImage,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Gizemli Kapak',
    chapterId: 'intro',
    narrationText:
        '{{heroName}} kitabı dikkatlice kaldırdı. Kapağındaki şeker, bulut ve kale çizimleri sanki hareket edecekmiş gibi ışıldıyordu.',
    ambientSound: 'ambient_neighborhood',
    entrySoundEffect: 'page_rustle',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'book_glows')],
  ),
  'book_glows': StoryPage(
    id: 'book_glows',
    backgroundImage: introBookGlowImage,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Parlayan Sayfalar',
    chapterId: 'intro',
    narrationText:
        '{{heroName}} kapağı açınca sayfalardan sıcak bir ışık yükseldi. Harfler kıpırdadı, çizimler birer birer canlandı.',
    ambientSound: 'ambient_magic',
    entrySoundEffect: 'magic_glow',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'portal_opens')],
  ),
  'portal_opens': StoryPage(
    id: 'portal_opens',
    backgroundImage: introPortalImage,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Açılan Portal',
    chapterId: 'intro',
    narrationText:
        'Kitabın ortasında dönen rengarenk bir geçit açıldı. Rüzgar hızlandı ve sayfalar iki arkadaşın çevresinde uçuştu.',
    ambientSound: 'ambient_magic',
    entrySoundEffect: 'page_portal',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'pulled_inside')],
  ),
  'pulled_inside': StoryPage(
    id: 'pulled_inside',
    backgroundImage: introPortalImage,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Kitabın İçine',
    chapterId: 'intro',
    narrationText:
        '{{heroName}}, {{friendName}}\'in elini tuttu. Bir anda dünya kağıttan bir fırtınaya dönüştü ve ikisi birlikte kitabın içine çekildi.',
    ambientSound: 'ambient_magic',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'candy_land')],
  ),
  'candy_land': StoryPage(
    id: 'candy_land',
    backgroundImage: candyArrivalImage,
    backgroundMotion: StoryBackgroundMotion.slowZoomOut,
    title: 'Şeker Diyarı',
    titleCardText: 'ŞEKER DİYARI',
    showTitleCard: true,
    chapterId: 'candy_land',
    narrationText:
        '{{heroName}} ve {{friendName}} pamuk şeker kadar yumuşak bir tepeye düştü. Gökyüzünde şeker renkli bulutlar yüzüyordu.',
    ambientSound: 'ambient_candy_land',
    entrySoundEffect: 'soft_chime',
    isCheckpoint: true,
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'candy_orientation')],
  ),
  'candy_orientation': StoryPage(
    id: 'candy_orientation',
    backgroundImage: candyArrivalImage,
    title: 'Burası Neresi?',
    chapterId: 'candy_land',
    narrationText:
        'İki arkadaş ayağa kalkıp çevrelerine baktı. Lolipop ağaçları, bisküvi yolları ve uzakta parlayan küçük evler vardı.',
    ambientSound: 'ambient_candy_land',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'candy_village')],
  ),
  'candy_village': StoryPage(
    id: 'candy_village',
    backgroundImage: candyArrivalImage,
    backgroundMotion: StoryBackgroundMotion.panLeft,
    title: 'Şeker Köyü',
    chapterId: 'candy_land',
    narrationText:
        '{{friendName}} bisküvi yolu işaret etti. Çocuklar renkli evlere doğru ilerlerken çalılıkların ardından neşeli bir ses duyuldu.',
    ambientSound: 'ambient_candy_land',
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
        'Yumuşacık, gülümseyen Pofuduk ortaya çıktı. "Merhaba! Ben Pofuduk. Burası Şeker Diyarı," diyerek çocuklara el salladı.',
    ambientSound: 'ambient_candy_land',
    isCheckpoint: true,
    characterLayers: [
      StoryCharacterLayer(
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
      ),
    ],
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'pofuduk_explains')],
  ),
  'pofuduk_explains': StoryPage(
    id: 'pofuduk_explains',
    backgroundImage: candyPofudukImage,
    title: 'Pofuduk\'un Haberi',
    chapterId: 'candy_land',
    narrationText:
        'Pofuduk, Şeker Diyarı\'nın neşesini Bay Bayat\'ın bozduğunu anlattı. "Şeker Kalesi\'ne ulaşırsak neler olduğunu öğrenebiliriz," dedi.',
    ambientSound: 'ambient_candy_land',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'first_candy_choice')],
  ),
  'first_candy_choice': StoryPage(
    id: 'first_candy_choice',
    backgroundImage: candyPofudukImage,
    title: 'İlk Karar',
    chapterId: 'candy_land',
    narrationText:
        'Pofuduk iki yolu gösterdi. Biri onun bildiği bisküvi patikasıydı; diğeri rengarenk şeker çiçeklerinin arasından geçiyordu.',
    ambientSound: 'ambient_candy_land',
    choices: [
      StoryChoice(text: 'Pofuduk\'u takip et', nextPageId: 'follow_pofuduk'),
      StoryChoice(text: 'Önce etrafı incele', nextPageId: 'look_around'),
    ],
  ),
  'follow_pofuduk': StoryPage(
    id: 'follow_pofuduk',
    backgroundImage: candyPofudukImage,
    title: 'Bisküvi Patikası',
    chapterId: 'candy_land',
    narrationText:
        'Pofuduk zıplaya zıplaya önden gitti. {{heroName}} ile {{friendName}}, onun bıraktığı küçük şeker tozu izlerini takip etti.',
    ambientSound: 'ambient_candy_land',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'caramel_warning')],
  ),
  'look_around': StoryPage(
    id: 'look_around',
    backgroundImage: candyArrivalImage,
    backgroundMotion: StoryBackgroundMotion.panLeft,
    title: 'Şeker Çiçekleri',
    chapterId: 'candy_land',
    narrationText:
        'Çocuklar şeker çiçeklerinin arasında parlayan karamel ayak izleri buldu. İzler kıvrılıp yeniden Pofuduk\'un patikasına çıktı.',
    ambientSound: 'ambient_candy_land',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'caramel_warning')],
  ),
  'caramel_warning': StoryPage(
    id: 'caramel_warning',
    backgroundImage: candyCaramelChaseImage,
    backgroundMotion: StoryBackgroundMotion.panRight,
    title: 'Karamel Tehlikesi',
    chapterId: 'candy_land',
    narrationText:
        'Yolun önünde yapışkan karamel dalgaları kıpırdıyordu. Pofuduk güvenli taşları gösterdi, fakat parlak bir kestirme de çok yakın görünüyordu.',
    ambientSound: 'ambient_candy_land',
    entrySoundEffect: 'caramel_roll',
    isCheckpoint: true,
    choices: [
      StoryChoice(
        text: 'Güvenli taşlardan ilerle',
        nextPageId: 'caramel_chase',
      ),
      StoryChoice(text: 'Parlak kestirmeyi dene', nextPageId: 'caramel_trap'),
    ],
  ),
  'caramel_trap': StoryPage(
    id: 'caramel_trap',
    backgroundImage: candyCaramelChaseImage,
    backgroundMotion: StoryBackgroundMotion.panRight,
    title: 'Yapışkan Kestirme',
    chapterId: 'candy_land',
    narrationText:
        'Kestirme bir anda ayakkabılarına yapıştı. {{friendName}}, {{heroName}}\'i kolundan çekti; ikisi güçlerini birleştirip son anda kurtuldu.',
    ambientSound: 'ambient_candy_land',
    choices: [
      StoryChoice(text: 'Güvenli noktaya dön', nextPageId: 'caramel_warning'),
    ],
  ),
  'caramel_chase': StoryPage(
    id: 'caramel_chase',
    backgroundImage: candyCaramelChaseImage,
    backgroundMotion: StoryBackgroundMotion.panRight,
    title: 'Karamel Kovalamacası',
    chapterId: 'candy_land',
    narrationText:
        'Tam son taşa geldiklerinde kocaman bir karamel dalgası peşlerinden yuvarlandı. Pofuduk ileri atıldı ve güvenli tepeyi gösterdi.',
    ambientSound: 'ambient_candy_land',
    choices: [StoryChoice(text: 'Birlikte koş', nextPageId: 'help_each_other')],
  ),
  'help_each_other': StoryPage(
    id: 'help_each_other',
    backgroundImage: candyCaramelChaseImage,
    backgroundMotion: StoryBackgroundMotion.panRight,
    title: 'Birlikte Daha Güçlü',
    chapterId: 'candy_land',
    narrationText:
        '{{heroName}} öndeki dala tutundu, {{friendName}} de onun elini yakaladı. Birbirlerini çekerek karamel dalgasından birlikte kurtuldular.',
    ambientSound: 'ambient_candy_land',
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'paths_rejoin')],
  ),
  'paths_rejoin': StoryPage(
    id: 'paths_rejoin',
    backgroundImage: candyCaramelChaseImage,
    title: 'Yollar Birleşiyor',
    chapterId: 'candy_land',
    narrationText:
        'Pofuduk derin bir nefes aldı. Hangi yolu seçmiş olurlarsa olsunlar artık üçü aynı tepenin zirvesine doğru ilerliyordu.',
    ambientSound: 'ambient_candy_land',
    choices: [StoryChoice(text: 'Tepeye çık', nextPageId: 'castle_view')],
  ),
  'castle_view': StoryPage(
    id: 'castle_view',
    backgroundImage: candyCastleShadowImage,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Şeker Kalesi',
    titleCardText: 'ŞEKER KALESİ',
    showTitleCard: true,
    chapterId: 'candy_land',
    narrationText:
        'Tepenin ardından dev kuleleriyle Şeker Kalesi göründü. Renkli duvarların üstünde tuhaf, gri bir gölge dolaşıyordu.',
    ambientSound: 'ambient_castle',
    isCheckpoint: true,
    choices: [StoryChoice(text: 'Devam et', nextPageId: 'bay_bayat_shadow')],
  ),
  'bay_bayat_shadow': StoryPage(
    id: 'bay_bayat_shadow',
    backgroundImage: candyCastleShadowImage,
    backgroundMotion: StoryBackgroundMotion.slowZoomIn,
    title: 'Bay Bayat\'ın Gölgesi',
    chapterId: 'candy_land',
    narrationText:
        'Kaleden soğuk bir rüzgar esti. Pofuduk sessizce, "Bay Bayat bizi fark etti," dedi. {{heroName}} ile {{friendName}} birbirine kararlılıkla baktı.',
    ambientSound: 'ambient_castle',
    choices: [
      StoryChoice(text: 'Bölümü tamamla', nextPageId: candyChapterEndPageId),
    ],
  ),
};
