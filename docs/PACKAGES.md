# Что отключает модуль

Имена пакетов отличаются между Global, EEA, CN и RU-прошивками. Если пакета нет —
модуль просто пропускает его. Перед отключением всегда запускай `scan.sh`.

| Пакет | Что это | Профиль |
|---|---|---|
| `com.miui.analytics` | Аналитика Xiaomi | safe+ |
| `com.miui.systemAdSolution` | Реклама в системных приложениях | safe+ |
| `com.miui.msa.global` | Рекомендации и рекламные сервисы | safe+ |
| `com.miui.yellowpage` | «Жёлтые страницы», мусорный контент | safe+ |
| `com.miui.bugreport` | Отправка отчётов об ошибках | safe+ |
| `com.android.browser` | Встроенный браузер (Global) | balanced+ |
| `com.miui.browser` | Встроенный браузер (CN) | balanced+ |
| `com.xiaomi.mipicks` | GetApps / магазин приложений | balanced+ |
| `com.miui.market` | Магазин приложений (CN) | balanced+ |
| `com.xiaomi.shop` | Магазин Xiaomi | balanced+ |
| `com.miui.videoplayer` | Mi Video | balanced+ |
| `com.miui.video` | Видеосервис | balanced+ |
| `com.xiaomi.mirror` | Зеркалирование экрана / Miracast | balanced+ |
| `com.xiaomi.scanner` | Сканер QR и штрихкодов | balanced+ |
| `com.miui.hybrid` | Гибридные сервисы / Mi Connect | balanced+ |
| `com.xiaomi.joyose` | Производительность, игры и аналитика | aggressive |
| `com.xiaomi.discover` | Рекомендательные сервисы | aggressive |
| `com.miui.aod` | Always-On Display | aggressive |
| `com.miui.miwallpaper` | Каталог обоев | aggressive |
| `com.miui.voiceassist` | Голосовой помощник | aggressive |
| `com.miui.powerkeeper` | Политики энергопотребления и фона | aggressive |
| `com.miui.luckymoney` | «Красные конверты» | aggressive |
| `com.miui.gamebooster` | Игровой режим | aggressive |

`safe+` означает, что пакет входит во все три профиля.

## Никогда не трогается

`com.miui.home`, `com.miui.keyguard`, `com.miui.securitycenter`, `com.miui.securitycore`,
`com.miui.theme`, `com.miui.backup`, `com.miui.face`, `com.miui.gallery`, `com.miui.notes`,
`com.miui.calculator`, `com.mipay.wallet`, `com.xiaomi.payment`, `com.xiaomi.finddevice`,
`com.xiaomi.smarthome`, `com.google.android.gms` — это whitelist по умолчанию.
