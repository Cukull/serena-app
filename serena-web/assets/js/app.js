/**
 * SERENA APP - CORE INTERACTIVE CONTROLLER
 * Menangani interaksi Home, Jadwal/Planner, Detail Tugas, Detail Jadwal, dan Statistik.
 * Mendukung navigasi SPA (Single Page Application) dan mode file standalone (/pages/*).
 */

document.addEventListener('DOMContentLoaded', () => {
  initClock();
  initFocusTimer();
  initTabNavigation();
  initHomeCardNavigation();
  initStatistikControls();
  initPlannerControls();
  initDetailPageControls();
  initProfileControls();
  initNotificationToast();
});

/* -------------------------------------------------------------------------- */
/* 1. STATUS BAR REAL-TIME CLOCK                                               */
/* -------------------------------------------------------------------------- */
function initClock() {
  const clockEl = document.getElementById('statusClock');
  if (!clockEl) return;

  function updateClock() {
    const now = new Date();
    let hours = now.getHours();
    let minutes = now.getMinutes();
    hours = hours < 10 ? '0' + hours : hours;
    minutes = minutes < 10 ? '0' + minutes : minutes;
    clockEl.textContent = `${hours}:${minutes}`;
  }

  updateClock();
  setInterval(updateClock, 30000);
}

/* -------------------------------------------------------------------------- */
/* 2. FOCUS TIMER CONTROLS (HOME BANNER)                                      */
/* -------------------------------------------------------------------------- */
function initFocusTimer() {
  const timerDisplay = document.getElementById('focusTimerDisplay');
  const btnPauseFocus = document.getElementById('btnPauseFocus');
  const pauseBtnLabel = document.getElementById('pauseBtnLabel');
  const pauseBtnIcon = document.getElementById('pauseBtnIcon');
  const focusStatusText = document.getElementById('focusStatusText');
  const pulseDot = document.getElementById('pulseDot');

  if (!timerDisplay || !btnPauseFocus) return;

  let totalSeconds = 18 * 60 + 42;
  let isRunning = true;
  let timerInterval = null;

  function formatTime(seconds) {
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  }

  function startTimer() {
    if (timerInterval) clearInterval(timerInterval);
    timerInterval = setInterval(() => {
      if (totalSeconds > 0) {
        totalSeconds--;
        timerDisplay.textContent = formatTime(totalSeconds);
      } else {
        clearInterval(timerInterval);
        isRunning = false;
        updateUI();
        showNotification('Sesi fokus selesai! Waktunya istirahat sejenak ☕');
      }
    }, 1000);
  }

  function pauseTimer() {
    clearInterval(timerInterval);
    timerInterval = null;
  }

  function updateUI() {
    const heroCard = document.getElementById('focusHeroCard');
    if (isRunning) {
      if (heroCard) heroCard.classList.remove('timer-paused');
      if (pauseBtnLabel) pauseBtnLabel.textContent = 'Jeda Fokus';
      if (focusStatusText) focusStatusText.textContent = 'Sedang fokus';
      if (pulseDot) {
        pulseDot.style.backgroundColor = 'var(--color-success)';
        pulseDot.style.animationPlayState = 'running';
      }
      if (pauseBtnIcon) {
        pauseBtnIcon.innerHTML = `
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="3" stroke-linecap="round">
            <line x1="10" y1="5" x2="10" y2="19"></line>
            <line x1="14" y1="5" x2="14" y2="19"></line>
          </svg>
        `;
      }
    } else {
      if (heroCard) heroCard.classList.add('timer-paused');
      if (pauseBtnLabel) pauseBtnLabel.textContent = 'Lanjutkan';
      if (focusStatusText) focusStatusText.textContent = 'Sesi terjeda';
      if (pulseDot) {
        pulseDot.style.backgroundColor = '#F59E0B';
        pulseDot.style.animationPlayState = 'paused';
      }
      if (pauseBtnIcon) {
        pauseBtnIcon.innerHTML = `
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
            <polygon points="5 3 19 12 5 21 5 3" fill="#ffffff"></polygon>
          </svg>
        `;
      }
    }
  }

  btnPauseFocus.addEventListener('click', () => {
    isRunning = !isRunning;
    if (isRunning) {
      startTimer();
    } else {
      pauseTimer();
    }
    updateUI();
  });

  // Interactive click on Hourglass Artwork: trigger spin flip
  const heroArtwork = document.querySelector('.hero-artwork');
  if (heroArtwork) {
    heroArtwork.addEventListener('click', () => {
      heroArtwork.classList.add('spin-now');
      setTimeout(() => heroArtwork.classList.remove('spin-now'), 900);
      showNotification('Jam pasir dibalik! ⏳');
    });
  }

  startTimer();
}

/* -------------------------------------------------------------------------- */
/* 3. UNIVERSAL ROUTER & NAVIGATION CONTROLLER                                */
/* -------------------------------------------------------------------------- */
let activeView = 'home';

/**
 * Universal navigateTo helper:
 * - If target view element exists in DOM (SPA root index.html), switches view in place.
 * - If target view does NOT exist in DOM (standalone page), navigates to page file with query params.
 */
function navigateTo(target, params = {}) {
  const routeMap = {
    home: { viewId: 'viewHome', pageDir: 'home' },
    detailTugas: { viewId: 'viewDetailTugas', pageDir: 'detail-tugas' },
    detailJadwal: { viewId: 'viewDetailJadwal', pageDir: 'detail-jadwal' },
    statistik: { viewId: 'viewStatistik', pageDir: 'statistik' },
    jadwal: { viewId: 'viewJadwal', pageDir: 'jadwal' },
    fokus: { viewId: null, pageDir: 'fokus' },
    profile: { viewId: 'viewProfile', pageDir: 'profile' },
    akun: { viewId: 'viewProfile', pageDir: 'profile' }
  };

  const route = routeMap[target] || { viewId: null, pageDir: target };
  const targetViewEl = route.viewId ? document.getElementById(route.viewId) : null;

  // 1. In-page SPA switching if target container is in current DOM
  if (targetViewEl) {
    switchView(target);
    if (target === 'statistik') {
      if (params.metric) setStatMetric(params.metric);
      if (params.period) updateStatPeriod(params.period);
    } else if (target === 'detailTugas') {
      if (params.task) updateDetailTugasContent(params.task);
    } else if (target === 'detailJadwal') {
      if (params.title) updateDetailJadwalContent(params.title);
    } else if (target === 'jadwal') {
      if (params.tab && typeof setPlannerTab === 'function') setPlannerTab(params.tab);
    }
    return;
  }

  // 2. Multi-page Standalone File Navigation
  const normalizedPath = window.location.pathname.replace(/\\/g, '/');
  const isInsidePages = normalizedPath.includes('/pages/');
  const prefix = isInsidePages ? '../' : 'pages/';
  let url = `${prefix}${route.pageDir}/index.html`;

  const queryParts = [];
  if (params.task) queryParts.push(`task=${encodeURIComponent(params.task)}`);
  if (params.metric) queryParts.push(`metric=${encodeURIComponent(params.metric)}`);
  if (params.period) queryParts.push(`period=${encodeURIComponent(params.period)}`);
  if (params.tab) queryParts.push(`tab=${encodeURIComponent(params.tab)}`);
  if (params.title) queryParts.push(`title=${encodeURIComponent(params.title)}`);

  if (queryParts.length > 0) {
    url += `?${queryParts.join('&')}`;
  }

  window.location.href = url;
}

/**
 * Switch view when in SPA mode (index.html)
 */
function switchView(viewName) {
  const views = {
    home: document.getElementById('viewHome'),
    detailTugas: document.getElementById('viewDetailTugas'),
    detailJadwal: document.getElementById('viewDetailJadwal'),
    statistik: document.getElementById('viewStatistik'),
    jadwal: document.getElementById('viewJadwal'),
    profile: document.getElementById('viewProfile'),
    akun: document.getElementById('viewProfile'),
    generic: document.getElementById('viewGeneric')
  };

  // If view is not in current DOM, fallback to navigateTo
  if (!views[viewName]) {
    navigateTo(viewName);
    return;
  }

  const header = document.querySelector('.app-header');
  const bottomNav = document.querySelector('.bottom-nav-dock-container');
  const scrollContainer = document.querySelector('.app-content-scroll');

  // Hide all views
  Object.values(views).forEach(v => {
    if (v) v.style.display = 'none';
  });

  // Show target view
  if (views[viewName]) {
    views[viewName].style.display = 'flex';
    activeView = viewName;
  }

  // Scroll to top
  if (scrollContainer) {
    scrollContainer.scrollTop = 0;
  }

  // Contextual header & navigation
  if (viewName === 'home') {
    if (header) header.style.display = 'flex';
    if (bottomNav) bottomNav.style.display = 'flex';
    setBottomNavActive('home');
  } else if (viewName === 'profile' || viewName === 'akun') {
    if (header) header.style.display = 'none';
    if (bottomNav) bottomNav.style.display = 'flex';
    setBottomNavActive('akun');
  } else if (viewName === 'statistik' || viewName === 'detailTugas' || viewName === 'detailJadwal' || viewName === 'jadwal') {
    if (header) header.style.display = 'none';
    if (bottomNav) bottomNav.style.display = 'flex';
    if (viewName === 'jadwal') setBottomNavActive('jadwal');
  } else {
    if (header) header.style.display = 'flex';
    if (bottomNav) bottomNav.style.display = 'flex';
  }
}

function setBottomNavActive(tabName) {
  const tabs = document.querySelectorAll('.nav-tab-item');
  tabs.forEach(tab => {
    if (tab.getAttribute('data-tab') === tabName) {
      tab.classList.add('active');
    } else {
      tab.classList.remove('active');
    }
  });
}

function handleSmartBack(fallbackTarget = 'home') {
  if (activeView !== 'home' && document.getElementById('viewHome')) {
    switchView('home');
    return;
  }
  if (window.history.length > 1 && document.referrer && document.referrer.includes(window.location.host)) {
    window.history.back();
  } else {
    navigateTo(fallbackTarget);
  }
}

/* -------------------------------------------------------------------------- */
/* 4. HOME CARDS NAVIGATION INTERACTION                                       */
/* -------------------------------------------------------------------------- */
function initHomeCardNavigation() {
  // User Header Avatar -> Profil
  const headerAvatar = document.getElementById('headerUserAvatar');
  if (headerAvatar) {
    headerAvatar.style.cursor = 'pointer';
    headerAvatar.addEventListener('click', () => {
      navigateTo('profile');
    });
  }

  // A. Tenggat Terdekat Card -> Detail Tugas
  const deadlineCard = document.getElementById('deadlineCard');
  if (deadlineCard) {
    deadlineCard.style.cursor = 'pointer';
    deadlineCard.addEventListener('click', () => {
      navigateTo('detailTugas', { task: 'Tugas Web Development' });
    });
  }

  // B. Agenda Tugas Item -> Detail Tugas
  const agendaTugasItem = document.getElementById('agendaTugasItem');
  if (agendaTugasItem) {
    agendaTugasItem.style.cursor = 'pointer';
    agendaTugasItem.addEventListener('click', () => {
      navigateTo('detailTugas', { task: 'Tugas Web Development' });
    });
  }

  // C. Agenda Kuliah Item -> Detail Jadwal
  const agendaKuliahItem = document.getElementById('agendaKuliahItem');
  if (agendaKuliahItem) {
    agendaKuliahItem.style.cursor = 'pointer';
    agendaKuliahItem.addEventListener('click', () => {
      navigateTo('detailJadwal', { title: 'Kuliah UI/UX Design' });
    });
  }

  // D. Linked Task di dalam Detail Jadwal -> Detail Tugas
  const linkedTugasItem = document.getElementById('linkedTugasItem');
  if (linkedTugasItem) {
    linkedTugasItem.style.cursor = 'pointer';
    linkedTugasItem.addEventListener('click', (e) => {
      e.preventDefault();
      navigateTo('detailTugas', { task: 'Tugas Web Development' });
    });
  }

  // E. Header Statistik Harian ("Statistik Harian" / "Lihat grafik ->")
  const headerStatistikHarian = document.getElementById('headerStatistikHarian');
  if (headerStatistikHarian) {
    headerStatistikHarian.style.cursor = 'pointer';
    headerStatistikHarian.addEventListener('click', () => {
      navigateTo('statistik', { metric: 'tasks' });
    });
  }

  // F. Kartu Statistik Harian Individual
  const statCardTasks = document.getElementById('statCardTasks');
  if (statCardTasks) {
    statCardTasks.style.cursor = 'pointer';
    statCardTasks.addEventListener('click', () => {
      navigateTo('statistik', { metric: 'tasks' });
    });
  }

  const statCardFocus = document.getElementById('statCardFocus');
  if (statCardFocus) {
    statCardFocus.style.cursor = 'pointer';
    statCardFocus.addEventListener('click', () => {
      navigateTo('statistik', { metric: 'focus' });
    });
  }

  const statCardDone = document.getElementById('statCardDone');
  if (statCardDone) {
    statCardDone.style.cursor = 'pointer';
    statCardDone.addEventListener('click', () => {
      navigateTo('statistik', { metric: 'done' });
    });
  }

  // Fallback selector for stat cards without explicit ID
  const statCards = document.querySelectorAll('.stat-card');
  const metricsOrder = ['tasks', 'focus', 'done'];
  statCards.forEach((card, index) => {
    if (!card.id) {
      card.style.cursor = 'pointer';
      card.addEventListener('click', () => {
        navigateTo('statistik', { metric: metricsOrder[index] || 'tasks' });
      });
    }
  });

  // G. Link "Lihat semua" Tenggat Terdekat -> Jadwal
  const linkDeadlineSeeAll = document.getElementById('linkDeadlineSeeAll');
  if (linkDeadlineSeeAll) {
    linkDeadlineSeeAll.style.cursor = 'pointer';
    linkDeadlineSeeAll.addEventListener('click', (e) => {
      e.preventDefault();
      navigateTo('jadwal', { tab: 'bataswaktu' });
    });
  }
}

/* -------------------------------------------------------------------------- */
/* 5. STATISTIK TAB & PERIOD SWITCHER (HARIAN, MINGGUAN, BULANAN)             */
/* -------------------------------------------------------------------------- */
const statData = {
  harian: {
    title: 'Tugas tersisa · Hari ini',
    val: '3 tugas',
    trendText: '0% vs hari sebelumnya',
    trendClass: 'neutral',
    yScale: ['6', '4', '2', '0'],
    bars: [
      { label: 'Sel', val: 65 },
      { label: 'Rab', val: 35 },
      { label: 'Kam', val: 80 },
      { label: 'Jum', val: 50 },
      { label: 'Sab', val: 20 },
      { label: 'Min', val: 35 },
      { label: 'Sen', val: 50, active: true }
    ],
    tertinggi: '6 tugas',
    rata: '4 tugas / hari',
    insight: 'Tugas tersisamu sama seperti hari sebelumnya. Pertahankan ritme ini!'
  },
  mingguan: {
    title: 'Tugas tersisa · Minggu ini',
    val: '3 tugas',
    trendText: '▼ 40% vs minggu sebelumnya',
    trendClass: '',
    yScale: ['9', '6', '3', '0'],
    bars: [
      { label: '29 Sep', val: 78 },
      { label: '6 Okt', val: 67 },
      { label: '13 Okt', val: 56 },
      { label: '20 Okt', val: 44 },
      { label: '27 Okt', val: 44 },
      { label: '3 Nov', val: 33, active: true }
    ],
    tertinggi: '7 tugas',
    rata: '5 tugas / minggu',
    insight: 'Tugas tersisamu berkurang 40% dibanding minggu sebelumnya. Pertahankan ritme ini!'
  },
  bulanan: {
    title: 'Tugas tersisa · Bulan ini',
    val: '4 tugas',
    trendText: '▼ 43% vs bulan sebelumnya',
    trendClass: '',
    yScale: ['9', '6', '3', '0'],
    bars: [
      { label: 'Jun', val: 100 },
      { label: 'Jul', val: 88 },
      { label: 'Agu', val: 77 },
      { label: 'Sep', val: 66 },
      { label: 'Okt', val: 55 },
      { label: 'Nov', val: 44, active: true }
    ],
    tertinggi: '9 tugas',
    rata: '6,8 tugas / bulan',
    insight: 'Tugas tersisamu berkurang 43% dibanding bulan sebelumnya. Pertahankan ritme ini!'
  }
};

let currentPeriod = 'harian';
let currentMetric = 'tasks';

function initStatistikControls() {
  const periodBtns = document.querySelectorAll('.period-tab-btn');
  periodBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      periodBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      const period = btn.getAttribute('data-period');
      updateStatPeriod(period);
    });
  });

  const filterItems = document.querySelectorAll('.stat-filter-item');
  filterItems.forEach(item => {
    item.addEventListener('click', () => {
      filterItems.forEach(fi => fi.classList.remove('active'));
      item.classList.add('active');
      const metric = item.getAttribute('data-metric');
      setStatMetric(metric);
    });
  });

  // Tombol Kembali di Halaman Statistik
  const btnStatBack = document.querySelector('.btn-stat-back') || document.getElementById('btnStatBack');
  if (btnStatBack) {
    btnStatBack.addEventListener('click', (e) => {
      e.preventDefault();
      handleSmartBack('home');
    });
  }

  // Parse query parameters on page load
  const urlParams = new URLSearchParams(window.location.search);
  const metricParam = urlParams.get('metric');
  if (metricParam) {
    setStatMetric(metricParam);
  }
  const periodParam = urlParams.get('period');
  if (periodParam) {
    updateStatPeriod(periodParam);
  }
}

function updateStatPeriod(period) {
  currentPeriod = period;
  const data = statData[period];
  if (!data) return;

  const titleEl = document.getElementById('chartMetricTitle');
  const valEl = document.getElementById('chartMetricVal');
  const trendBadge = document.getElementById('chartTrendBadge');
  const trendText = document.getElementById('chartTrendText');
  const yAxisEl = document.getElementById('chartYAxis');
  const barsWrapper = document.getElementById('chartBarsWrapper');
  const tertinggilEl = document.getElementById('statValTertinggi');
  const rataEl = document.getElementById('statValRata');
  const insightEl = document.getElementById('statInsightText');

  if (titleEl) titleEl.textContent = data.title;
  if (valEl) valEl.textContent = data.val;
  if (trendText) trendText.textContent = data.trendText;
  if (trendBadge) {
    if (data.trendClass === 'neutral') {
      trendBadge.className = 'stat-trend-badge neutral';
    } else {
      trendBadge.className = 'stat-trend-badge';
    }
  }

  if (tertinggilEl) tertinggilEl.textContent = data.tertinggi;
  if (rataEl) rataEl.textContent = data.rata;
  if (insightEl) insightEl.textContent = data.insight;

  // Render Y Scale
  if (yAxisEl && data.yScale) {
    yAxisEl.innerHTML = data.yScale.map(s => `<span>${s}</span>`).join('');
  }

  // Render Bars
  if (barsWrapper && data.bars) {
    barsWrapper.innerHTML = data.bars.map(b => `
      <div class="bar-column ${b.active ? 'active' : ''}">
        <div class="bar-pill" style="height: ${b.val}%;"></div>
        <span class="bar-label">${b.label}</span>
      </div>
    `).join('');
  }

  // Refresh metric label to match new period
  setStatMetric(currentMetric);
}

function setStatMetric(metric) {
  currentMetric = metric;
  const filterItems = document.querySelectorAll('.stat-filter-item');
  filterItems.forEach(fi => {
    if (fi.getAttribute('data-metric') === metric) {
      fi.classList.add('active');
    } else {
      fi.classList.remove('active');
    }
  });

  const titleEl = document.getElementById('chartMetricTitle');
  const valEl = document.getElementById('chartMetricVal');
  const labels = {
    tasks: { name: 'Tugas tersisa', val: '3 tugas' },
    focus: { name: 'Waktu fokus', val: '1j 40m' },
    done: { name: 'Tugas selesai', val: '2 tugas' }
  };

  const periodNames = { harian: 'Hari ini', mingguan: 'Minggu ini', bulanan: 'Bulan ini' };

  if (titleEl && labels[metric]) {
    titleEl.textContent = `${labels[metric].name} · ${periodNames[currentPeriod] || 'Hari ini'}`;
  }
  if (valEl && labels[metric]) {
    valEl.textContent = labels[metric].val;
  }
}

/* -------------------------------------------------------------------------- */
/* 6. DETAIL TUGAS & DETAIL JADWAL CONTROLLER (DYNAMIC DATA & BACK HANDLERS)  */
/* -------------------------------------------------------------------------- */
const taskDatabase = {
  'Tugas Web Development': {
    title: 'Tugas Web Development',
    course: 'Pemrograman Web · Sem. 6',
    badge: 'DEADLINE MENDEKAT',
    countdown: '06 jam 12 menit',
    deadline: 'Hari ini, 23.59 WIB',
    submission: 'Unggah via LMS',
    note: 'Buat website portofolio responsif dengan HTML & CSS (minimal 3 halaman), lengkap dengan navigasi dan galeri proyek. Kumpulkan dalam format .zip.'
  },
  'Tugas Database': {
    title: 'Tugas Database',
    course: 'Sistem Basis Data · Dr. Lia',
    badge: 'DEADLINE MALAM INI',
    countdown: '05 jam 18 menit',
    deadline: 'Hari ini, 23:59 WIB',
    submission: 'Unggah via LMS',
    note: 'Normalisasi skema relasional sistem inventori minimarket sampai 3NF dan sertakan query SQL DDL serta data dummy minimal 20 baris per tabel.'
  },
  'Presentasi AI': {
    title: 'Presentasi AI',
    course: 'AI · Prof. Dian',
    badge: 'DEADLINE MENDEKAT',
    countdown: '1 hari 16 jam',
    deadline: 'Jum, 9 Mei · 10:30 WIB',
    submission: 'Presentasi Luring · Ruang G1',
    note: 'Siapkan slide deck 10 halaman tentang implementasi algoritma A* Search dan Dijkstra dalam pencarian rute terpendek robotik.'
  },
  'Proyek Database': {
    title: 'Proyek Database',
    course: 'Proyek Database · MPK · Regen',
    badge: 'SEDANG BERLANGSUNG',
    countdown: '1 hari 5 jam',
    deadline: 'Besok, 23:59 WIB',
    submission: 'Unggah via LMS & Git Repo',
    note: 'Implementasi backend REST API menggunakan PostgreSQL, ORM Prisma, serta dokumentasi endpoint Swagger Postman.'
  },
  'Tugas UI/UX': {
    title: 'Tugas UI/UX',
    course: 'Kuliah Desain UI/UX',
    badge: 'DALAM PENGERJAAN',
    countdown: '2 hari tersisa',
    deadline: 'Sab, 10 Mei · 23:59 WIB',
    submission: 'Tautan Figma Interaktif',
    note: 'Buat wireframe high-fidelity dan clickable prototype aplikasi Serena dengan variasi tema pastel serta status bar realistik.'
  },
  'UTS Algoritma': {
    title: 'UTS Algoritma',
    course: 'Desain & Analisis Algoritma',
    badge: 'UJIAN MENDEKAT',
    countdown: '4 hari tersisa',
    deadline: 'Sen, 12 Mei · 10:00 WIB',
    submission: 'Ujian Tertulis · Ruang Ujian B',
    note: 'Materi ujian meliputi Teori Graf, Divide & Conquer, Dynamic Programming, dan Analisis Kompleksitas Asimptotik Big-O (Tutup Buku).'
  },
  'Kumpulan Soal Kalkulus': {
    title: 'Kumpulan Soal Kalkulus',
    course: 'Kalkulus · Dosen: Tiaza',
    badge: 'SELESAI DIKUMPULKAN',
    countdown: 'Selesai ✓',
    deadline: 'Rabu, 7 Mei · 14:00 WIB',
    submission: 'Terkonfirmasi via LMS',
    note: 'Latihan soal integral lipat dua dan kalkulus diferensial telah berhasil dikumpulkan dan diverifikasi dosen pengampu.'
  }
};

function updateDetailTugasContent(taskName) {
  const task = taskDatabase[taskName] || {
    title: taskName,
    course: 'Mata Kuliah',
    badge: 'INFORMASI TUGAS',
    countdown: 'Tenggat Waktu',
    deadline: '23:59 WIB',
    submission: 'LMS / Portal',
    note: `Detail dan instruksi pengerjaan untuk ${taskName}.`
  };

  const titleEls = document.querySelectorAll('.tugas-main-title');
  titleEls.forEach(el => el.textContent = task.title);

  const badgeEls = document.querySelectorAll('.tugas-deadline-badge');
  badgeEls.forEach(el => el.textContent = task.badge);

  const countdownEls = document.querySelectorAll('.tugas-countdown-time');
  countdownEls.forEach(el => el.textContent = task.countdown);

  const noteEls = document.querySelectorAll('.tugas-note-body');
  noteEls.forEach(el => el.textContent = task.note);
}

function updateDetailJadwalContent(courseTitle) {
  const titleEls = document.querySelectorAll('.jadwal-main-title');
  titleEls.forEach(el => el.textContent = courseTitle);
}

function initDetailPageControls() {
  // Check URL parameters on Detail Tugas page
  const urlParams = new URLSearchParams(window.location.search);
  const taskParam = urlParams.get('task');
  if (taskParam) {
    updateDetailTugasContent(taskParam);
  }

  const titleParam = urlParams.get('title');
  if (titleParam) {
    updateDetailJadwalContent(titleParam);
  }

  // Tombol Kembali di Detail Tugas
  const btnTugasKembaliList = document.querySelectorAll('.btn-tugas-kembali, #btnTugasKembali');
  btnTugasKembaliList.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      handleSmartBack('home');
    });
  });

  // Tombol Kembali di Detail Jadwal
  const btnJadwalKembaliList = document.querySelectorAll('.btn-jadwal-kembali, #btnJadwalKembali');
  btnJadwalKembaliList.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      handleSmartBack('home');
    });
  });

  // Tombol Lihat Tugas di Detail Tugas
  const btnTugasLihat = document.getElementById('btnTugasLihat');
  if (btnTugasLihat) {
    btnTugasLihat.addEventListener('click', () => {
      showNotification('🚀 Membuka link pengumpulan LMS...');
    });
  }
}

/* -------------------------------------------------------------------------- */
/* 7. PLANNER & JADWAL CONTROLLER (Prototype Accurate)                        */
/* -------------------------------------------------------------------------- */
function initPlannerControls() {
  const plannerContainer = document.getElementById('plannerContainer');
  if (!plannerContainer) return;

  // Subviews
  const subviews = {
    main: document.getElementById('subViewPlannerMain'),
    tambah: document.getElementById('subViewTambahTugas'),
    konfirmasi: document.getElementById('subViewKonfirmasi'),
    terkonfirmasi: document.getElementById('subViewPengumpulanTerkonfirmasi'),
    tunda: document.getElementById('subViewTundaTugas'),
    tersimpan: document.getElementById('subViewPenundaanTersimpan'),
    sesi: document.getElementById('subViewSesiTugas')
  };

  function switchPlannerSubView(name) {
    Object.values(subviews).forEach(sv => {
      if (sv) sv.style.display = 'none';
    });
    if (subviews[name]) {
      subviews[name].style.display = 'flex';
    }
    const scrollContainer = document.querySelector('.app-content-scroll');
    if (scrollContainer) scrollContainer.scrollTop = 0;
  }

  // Planner main mode: 'month' (Dasbor Perencana) vs 'week' (Jadwal Mingguan)
  let plannerMode = 'month'; // default matches Screen 1
  const headerTitle = document.getElementById('plannerHeaderTitle');
  const monthCalendar = document.getElementById('plannerMonthCalendar');
  const weeklyHero = document.getElementById('plannerWeeklyHeroContainer');
  const btnPlannerBack = document.getElementById('btnPlannerBack');

  function setPlannerMode(mode) {
    plannerMode = mode;
    if (mode === 'month') {
      if (headerTitle) headerTitle.textContent = 'Dasbor Perencana';
      if (monthCalendar) monthCalendar.style.display = 'block';
      if (weeklyHero) weeklyHero.style.display = 'none';
      if (btnPlannerBack) btnPlannerBack.style.display = 'none';
    } else {
      if (headerTitle) headerTitle.textContent = 'Jadwal Mingguan';
      if (monthCalendar) monthCalendar.style.display = 'none';
      if (weeklyHero) weeklyHero.style.display = 'flex';
      if (btnPlannerBack) btnPlannerBack.style.display = 'flex';
    }
  }

  if (btnPlannerBack) {
    btnPlannerBack.addEventListener('click', () => {
      if (plannerMode === 'week') {
        setPlannerMode('month');
      } else {
        navigateTo('home');
      }
    });
  }

  const linkLihatSemua = document.getElementById('linkLihatSemuaKalender');
  if (linkLihatSemua) {
    linkLihatSemua.addEventListener('click', () => {
      setPlannerMode('month');
    });
  }

  // Calendar day cells click
  const calendarCells = document.querySelectorAll('.calendar-day-cell:not(.inactive-month)');
  calendarCells.forEach(cell => {
    cell.addEventListener('click', () => {
      calendarCells.forEach(c => c.classList.remove('selected'));
      cell.classList.add('selected');
      const dayNum = cell.getAttribute('data-day') || cell.textContent.trim();
      setPlannerMode('week');
      setWeekDayPillActive(dayNum);
    });
  });

  // Week day pills click
  const weekPills = document.querySelectorAll('.week-day-pill');
  function setWeekDayPillActive(dateNum) {
    weekPills.forEach(pill => {
      if (pill.getAttribute('data-date') === String(dateNum)) {
        pill.classList.add('active');
      } else {
        pill.classList.remove('active');
      }
    });
  }
  weekPills.forEach(pill => {
    pill.addEventListener('click', () => {
      weekPills.forEach(p => p.classList.remove('active'));
      pill.classList.add('active');
      const dateVal = pill.getAttribute('data-date');
      showNotification(`Menampilkan jadwal untuk ${dateVal} Mei 2025`);
    });
  });

  // Pekan Hero Stat Boxes Click Handlers
  const pekanStatKelas = document.getElementById('pekanStatKelas');
  if (pekanStatKelas) {
    pekanStatKelas.style.cursor = 'pointer';
    pekanStatKelas.addEventListener('click', () => {
      setPlannerTab('linimasa');
    });
  }
  const pekanStatTugas = document.getElementById('pekanStatTugas');
  if (pekanStatTugas) {
    pekanStatTugas.style.cursor = 'pointer';
    pekanStatTugas.addEventListener('click', () => {
      setPlannerTab('tugas');
    });
  }

  // Filter Tabs: [Lini Masa] [Batas Waktu] [Tugas]
  const tabLinimasa = document.getElementById('tabPlannerLinimasa');
  const tabBatasWaktu = document.getElementById('tabPlannerBatasWaktu');
  const tabTugas = document.getElementById('tabPlannerTugas');
  const contentLinimasa = document.getElementById('plannerTabContentLinimasa');
  const contentBatasWaktu = document.getElementById('plannerTabContentBatasWaktu');
  const contentTugas = document.getElementById('plannerTabContentTugas');

  function setPlannerTab(activeTab) {
    [tabLinimasa, tabBatasWaktu, tabTugas].forEach(t => {
      if (t) t.classList.remove('active');
    });
    if (contentLinimasa) contentLinimasa.style.display = 'none';
    if (contentBatasWaktu) contentBatasWaktu.style.display = 'none';
    if (contentTugas) contentTugas.style.display = 'none';

    if (activeTab === 'linimasa') {
      if (tabLinimasa) tabLinimasa.classList.add('active');
      if (contentLinimasa) contentLinimasa.style.display = 'flex';
    } else if (activeTab === 'bataswaktu') {
      if (tabBatasWaktu) tabBatasWaktu.classList.add('active');
      if (contentBatasWaktu) contentBatasWaktu.style.display = 'flex';
      setPlannerMode('week'); // Matches prototype Screen 2
    } else if (activeTab === 'tugas') {
      if (tabTugas) tabTugas.classList.add('active');
      if (contentTugas) contentTugas.style.display = 'flex';
      setPlannerMode('week'); // Matches prototype Screen 3
    }
  }

  if (tabLinimasa) tabLinimasa.addEventListener('click', () => setPlannerTab('linimasa'));
  if (tabBatasWaktu) tabBatasWaktu.addEventListener('click', () => setPlannerTab('bataswaktu'));
  if (tabTugas) tabTugas.addEventListener('click', () => setPlannerTab('tugas'));

  // Check URL param for tab
  const urlParams = new URLSearchParams(window.location.search);
  const tabParam = urlParams.get('tab');
  if (tabParam) {
    setPlannerTab(tabParam);
  }

  // Open Tambah Tugas Form
  const btnOpenAddTask = document.getElementById('btnOpenAddTask');
  if (btnOpenAddTask) {
    btnOpenAddTask.addEventListener('click', () => {
      switchPlannerSubView('tambah');
    });
  }

  const btnBackFromTambah = document.getElementById('btnBackFromTambah');
  const btnBatalTugasBaru = document.getElementById('btnBatalTugasBaru');
  if (btnBackFromTambah) btnBackFromTambah.addEventListener('click', () => switchPlannerSubView('main'));
  if (btnBatalTugasBaru) btnBatalTugasBaru.addEventListener('click', () => switchPlannerSubView('main'));

  // Tambah Form Pill Selectors
  function setupPillGroup(groupId) {
    const group = document.getElementById(groupId);
    if (!group) return;
    const btns = group.querySelectorAll('.form-pill-btn');
    btns.forEach(btn => {
      btn.addEventListener('click', () => {
        btns.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
      });
    });
  }
  setupPillGroup('groupJenisTugas');
  setupPillGroup('groupPrioritas');
  setupPillGroup('groupLokasi');

  // Submit Tambah Tugas
  const btnSimpanTugasBaru = document.getElementById('btnSimpanTugasBaru');
  if (btnSimpanTugasBaru) {
    btnSimpanTugasBaru.addEventListener('click', () => {
      const inputTitle = document.getElementById('inputNamaTugas');
      const title = (inputTitle && inputTitle.value.trim()) ? inputTitle.value.trim() : 'Tugas Baru';
      showNotification(`✓ Tugas "${title}" berhasil disimpan ke perencana!`);
      switchPlannerSubView('main');
      setPlannerTab('tugas');
    });
  }

  /* ---------------- LINI MASA TIMELINE CARDS ---------------- */
  const timelineKuliahCard = document.getElementById('timelineKuliahCard');
  if (timelineKuliahCard) {
    timelineKuliahCard.style.cursor = 'pointer';
    timelineKuliahCard.addEventListener('click', () => {
      navigateTo('detailJadwal', { title: 'Kuliah Desain UI/UX' });
    });
  }

  const timelineTugasDbCard = document.getElementById('timelineTugasDbCard');
  if (timelineTugasDbCard) {
    timelineTugasDbCard.style.cursor = 'pointer';
    timelineTugasDbCard.addEventListener('click', () => {
      navigateTo('detailTugas', { task: 'Tugas Database' });
    });
  }

  const timelineUtsCard = document.getElementById('timelineUtsCard');
  if (timelineUtsCard) {
    timelineUtsCard.style.cursor = 'pointer';
    timelineUtsCard.addEventListener('click', () => {
      navigateTo('detailTugas', { task: 'UTS Algoritma' });
    });
  }

  const timelineKalkulusCard = document.getElementById('timelineKalkulusCard');
  if (timelineKalkulusCard) {
    timelineKalkulusCard.style.cursor = 'pointer';
    timelineKalkulusCard.addEventListener('click', () => {
      navigateTo('detailTugas', { task: 'Kumpulan Soal Kalkulus' });
    });
  }

  /* ---------------- RINGKASAN TUGAS -> STATISTIK NAVIGATION ---------------- */
  const ringkasanHeaders = document.querySelectorAll('.ringkasan-header-row, #ringkasanHeaderBatasWaktu, #ringkasanHeaderTugas');
  ringkasanHeaders.forEach(rh => {
    rh.style.cursor = 'pointer';
    rh.title = 'Lihat statistik tugas';
    rh.addEventListener('click', () => {
      navigateTo('statistik', { metric: 'tasks' });
    });
  });

  const ringkasanCardsDone = document.querySelectorAll('.ringkasan-card-green, #ringkasanCardDoneBatasWaktu, #ringkasanCardDoneTugas');
  ringkasanCardsDone.forEach(rc => {
    rc.style.cursor = 'pointer';
    rc.title = 'Lihat tugas selesai di statistik';
    rc.addEventListener('click', (e) => {
      e.stopPropagation();
      navigateTo('statistik', { metric: 'done' });
    });
  });

  const ringkasanCardsTasks = document.querySelectorAll('.ringkasan-card-blue, #ringkasanCardTasksBatasWaktu, #ringkasanCardTasksTugas');
  ringkasanCardsTasks.forEach(rc => {
    rc.style.cursor = 'pointer';
    rc.title = 'Lihat tugas tersisa di statistik';
    rc.addEventListener('click', (e) => {
      e.stopPropagation();
      navigateTo('statistik', { metric: 'tasks' });
    });
  });

  /* ---------------- BATAS WAKTU & TUGAS TASK CARDS NAVIGATION ---------------- */
  // Generic handler for all task-card-item elements across Batas Waktu and Tugas tabs
  const allTaskCards = document.querySelectorAll('.task-card-item');
  allTaskCards.forEach(card => {
    card.classList.add('clickable-card');
    card.style.cursor = 'pointer';
    card.addEventListener('click', (e) => {
      // Ignore click if user clicked an action button (Konfirmasi, Mulai Fokus, Nanti, etc.)
      if (e.target.closest('button') || e.target.closest('a')) {
        return;
      }

      // Determine task title from data attribute or main title text
      const dataTask = card.getAttribute('data-task');
      const titleEl = card.querySelector('.task-card-main-title');
      const taskName = dataTask || (titleEl ? titleEl.textContent.trim() : 'Tugas');

      navigateTo('detailTugas', { task: taskName });
    });
  });

  /* ---------------- FLOW A: KONFIRMASI PENGUMPULAN ---------------- */
  const btnKonfirmasiBatasWaktu = document.getElementById('btnKonfirmasiBatasWaktu');
  if (btnKonfirmasiBatasWaktu) {
    btnKonfirmasiBatasWaktu.addEventListener('click', (e) => {
      e.stopPropagation();
      switchPlannerSubView('konfirmasi');
    });
  }
  const btnBackFromKonfirmasi = document.getElementById('btnBackFromKonfirmasi');
  const btnCancelKonfirmasi = document.getElementById('btnCancelKonfirmasi');
  if (btnBackFromKonfirmasi) btnBackFromKonfirmasi.addEventListener('click', () => switchPlannerSubView('main'));
  if (btnCancelKonfirmasi) btnCancelKonfirmasi.addEventListener('click', () => switchPlannerSubView('main'));

  const btnSubmitKonfirmasi = document.getElementById('btnSubmitKonfirmasi');
  if (btnSubmitKonfirmasi) {
    btnSubmitKonfirmasi.addEventListener('click', () => {
      switchPlannerSubView('terkonfirmasi');
    });
  }
  const btnBackFromTerkonfirmasi = document.getElementById('btnBackFromTerkonfirmasi');
  const btnBackToJadwalFromSuccess = document.getElementById('btnBackToJadwalFromSuccess');
  if (btnBackFromTerkonfirmasi) btnBackFromTerkonfirmasi.addEventListener('click', () => switchPlannerSubView('main'));
  if (btnBackToJadwalFromSuccess) btnBackToJadwalFromSuccess.addEventListener('click', () => switchPlannerSubView('main'));

  /* ---------------- FLOW B: TUNDA TUGAS ---------------- */
  const tundaBtns = document.querySelectorAll('.btn-trigger-tunda');
  const tundaTaskTitle = document.getElementById('tundaTaskTitle');
  const tundaCourseName = document.getElementById('tundaCourseName');
  tundaBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      const task = btn.getAttribute('data-task') || 'Tugas Database';
      const course = btn.getAttribute('data-course') || 'SISTEM BASIS DATA · DR. LIA';
      if (tundaTaskTitle) tundaTaskTitle.textContent = task;
      if (tundaCourseName) tundaCourseName.textContent = course;
      switchPlannerSubView('tunda');
    });
  });

  const tundaCards = document.querySelectorAll('#tundaOptionsGrid .tunda-option-card');
  const tundaPreviewBadge = document.getElementById('tundaPreviewBadge');
  const tundaPreviewClock = document.getElementById('tundaPreviewClock');
  let selectedTundaTime = '30 menit lagi';
  let selectedTundaClock = '10:11';

  tundaCards.forEach(card => {
    card.addEventListener('click', () => {
      tundaCards.forEach(c => {
        c.classList.remove('active');
        const icon = c.querySelector('svg');
        if (icon) icon.remove();
      });
      card.classList.add('active');
      card.insertAdjacentHTML('beforeend', '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#6366F1" stroke-width="3"><polyline points="20 6 9 17 4 12"></polyline></svg>');
      selectedTundaTime = card.getAttribute('data-tunda-time') || '30 menit lagi';
      selectedTundaClock = card.getAttribute('data-target-clock') || '10:11';
      if (tundaPreviewBadge) tundaPreviewBadge.textContent = `Pengingat baru · ${selectedTundaTime}`;
      if (tundaPreviewClock) tundaPreviewClock.textContent = `Hari ini · ${selectedTundaClock}`;
    });
  });

  const btnSimpanPengingatTunda = document.getElementById('btnSimpanPengingatTunda');
  const tersimpanBadgeText = document.getElementById('tersimpanBadgeText');
  const tersimpanClockText = document.getElementById('tersimpanClockText');
  if (btnSimpanPengingatTunda) {
    btnSimpanPengingatTunda.addEventListener('click', () => {
      if (tersimpanBadgeText) tersimpanBadgeText.textContent = selectedTundaTime;
      if (tersimpanClockText) tersimpanClockText.textContent = `Hari ini · ${selectedTundaClock}`;
      switchPlannerSubView('tersimpan');
    });
  }

  const btnBackFromTunda = document.getElementById('btnBackFromTunda');
  const btnBatalTunda = document.getElementById('btnBatalTunda');
  if (btnBackFromTunda) btnBackFromTunda.addEventListener('click', () => switchPlannerSubView('main'));
  if (btnBatalTunda) btnBatalTunda.addEventListener('click', () => switchPlannerSubView('main'));

  const btnBackFromTersimpan = document.getElementById('btnBackFromTersimpan');
  const btnBackToDaftarTugas = document.getElementById('btnBackToDaftarTugas');
  if (btnBackFromTersimpan) btnBackFromTersimpan.addEventListener('click', () => {
    switchPlannerSubView('main');
    setPlannerTab('tugas');
  });
  if (btnBackToDaftarTugas) btnBackToDaftarTugas.addEventListener('click', () => {
    switchPlannerSubView('main');
    setPlannerTab('tugas');
  });

  /* ---------------- FLOW C: SESI TUGAS (Focus Pomodoro) ---------------- */
  let sesiSeconds = 18 * 60 + 32;
  let sesiInterval = null;
  let sesiIsRunning = true;
  let selectedFocusMinutes = 25;
  let selectedBreakMinutes = 5;

  const sesiTimerDisplay = document.getElementById('sesiTimerDisplay');
  const btnSesiJeda = document.getElementById('btnSesiJeda');
  const btnSesiLanjut = document.getElementById('btnSesiLanjut');
  const sesiStatusLabel = document.getElementById('sesiStatusLabel');
  const sesiPulseDot = document.getElementById('sesiPulseDot');
  const btnSesiSelesai = document.getElementById('btnSesiSelesai');
  const btnSaveDuration = document.getElementById('btnSaveDuration');
  const stepperFokusVal = document.getElementById('stepperFokusVal');
  const stepperBreakVal = document.getElementById('stepperBreakVal');
  const sesiTimerSub = document.getElementById('sesiTimerSub');

  function formatSesiTime(sec) {
    const m = Math.floor(sec / 60);
    const s = sec % 60;
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  }

  function startSesiTimer(seconds) {
    if (seconds) sesiSeconds = seconds;
    if (sesiInterval) clearInterval(sesiInterval);
    sesiIsRunning = true;
    updateSesiUI();
    sesiInterval = setInterval(() => {
      if (sesiSeconds > 0) {
        sesiSeconds--;
        if (sesiTimerDisplay) sesiTimerDisplay.textContent = formatSesiTime(sesiSeconds);
      } else {
        stopSesiTimer();
        showNotification('🎉 Sesi fokus selesai! Waktunya rehat sejenak.');
      }
    }, 1000);
  }

  function stopSesiTimer() {
    if (sesiInterval) clearInterval(sesiInterval);
    sesiInterval = null;
    sesiIsRunning = false;
    updateSesiUI();
  }

  function updateSesiUI() {
    if (sesiIsRunning) {
      if (sesiStatusLabel) sesiStatusLabel.textContent = 'Sedang fokus';
      if (sesiPulseDot) {
        sesiPulseDot.style.background = '#6366F1';
        sesiPulseDot.style.animationPlayState = 'running';
      }
    } else {
      if (sesiStatusLabel) sesiStatusLabel.textContent = 'Sesi dijeda';
      if (sesiPulseDot) {
        sesiPulseDot.style.background = '#F59E0B';
        sesiPulseDot.style.animationPlayState = 'paused';
      }
    }
  }

  const fokusBtns = document.querySelectorAll('.btn-trigger-fokus');
  const sesiTaskName = document.getElementById('sesiTaskName');
  const sesiCourseName = document.getElementById('sesiCourseName');
  fokusBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.stopPropagation();
      const task = btn.getAttribute('data-task') || 'Tugas Database';
      const course = btn.getAttribute('data-course') || 'SISTEM BASIS DATA · DR. LIA';
      if (sesiTaskName) sesiTaskName.textContent = task;
      if (sesiCourseName) sesiCourseName.textContent = course;
      switchPlannerSubView('sesi');
      startSesiTimer(selectedFocusMinutes * 60);
    });
  });

  const btnBackFromSesiTugas = document.getElementById('btnBackFromSesiTugas');
  if (btnBackFromSesiTugas) {
    btnBackFromSesiTugas.addEventListener('click', () => {
      stopSesiTimer();
      switchPlannerSubView('main');
    });
  }

  if (btnSesiJeda) {
    btnSesiJeda.addEventListener('click', () => {
      stopSesiTimer();
    });
  }

  if (btnSesiLanjut) {
    btnSesiLanjut.addEventListener('click', () => {
      startSesiTimer();
    });
  }

  // Duration Selection Pills
  const focusPills = document.querySelectorAll('#sesiFocusPills .duration-pill-btn');
  focusPills.forEach(fp => {
    fp.addEventListener('click', () => {
      focusPills.forEach(p => p.classList.remove('active'));
      fp.classList.add('active');
      selectedFocusMinutes = parseInt(fp.getAttribute('data-fokus') || '25');
      if (stepperFokusVal) stepperFokusVal.textContent = selectedFocusMinutes;
    });
  });

  const breakPills = document.querySelectorAll('#sesiBreakPills .duration-pill-btn');
  breakPills.forEach(bp => {
    bp.addEventListener('click', () => {
      breakPills.forEach(p => p.classList.remove('active'));
      bp.classList.add('active');
      selectedBreakMinutes = parseInt(bp.getAttribute('data-break') || '5');
      if (stepperBreakVal) stepperBreakVal.textContent = selectedBreakMinutes;
    });
  });

  if (btnSaveDuration) {
    btnSaveDuration.addEventListener('click', () => {
      startSesiTimer(selectedFocusMinutes * 60);
      if (sesiTimerSub) {
        sesiTimerSub.textContent = `Waktu tersisa: fokus ${selectedFocusMinutes} menit / istirahat ${selectedBreakMinutes} min`;
      }
      showNotification(`⏱️ Durasi sesi fokus disetel ${selectedFocusMinutes} menit.`);
    });
  }

  if (btnSesiSelesai) {
    btnSesiSelesai.addEventListener('click', () => {
      stopSesiTimer();
      showNotification('🎉 Sesi fokus selesai dan tersimpan!');
      switchPlannerSubView('main');
    });
  }
}

/* -------------------------------------------------------------------------- */
/* 8. BOTTOM NAVIGATION DOCK                                                  */
/* -------------------------------------------------------------------------- */
function initTabNavigation() {
  const tabs = document.querySelectorAll('.nav-tab-item');

  tabs.forEach(tab => {
    tab.addEventListener('click', (e) => {
      const targetTab = tab.getAttribute('data-tab');
      if (!targetTab) return; // Allow natural anchor link if no data-tab

      e.preventDefault();
      if (targetTab === 'home') {
        navigateTo('home');
      } else if (targetTab === 'jadwal') {
        navigateTo('jadwal');
      } else if (targetTab === 'fokus') {
        navigateTo('fokus');
      } else if (targetTab === 'akun') {
        navigateTo('profile');
      }
    });
  });
}

/* -------------------------------------------------------------------------- */
/* 8. PROFILE & ACCOUNT CONTROLLER (FIGMA PROTOTYPE 3 VIEWS & SHEETS)         */
/* -------------------------------------------------------------------------- */
function initProfileControls() {
  const container = document.getElementById('profileViewContainer') || document.getElementById('subViewProfileMain');
  if (!container) return;

  // Profile data state
  const P = {
    name: 'Yusup Arief Fauzi',
    email: 'yusup.arief@gmail.com',
    phone: '+62 812–3456–7890',
    dob: '2002-03-15',
    uni: 'Bandung Tech University',
    major: 'Ilmu Komputer',
    nim: '2021-CS-0847',
    chips: ['Coding 💻', 'UI/UX ✨', 'Kesehatan 🌿', 'Musik 🎵', 'Membaca 📚', 'Jurnal ✍️', 'Yoga 🧘'],
    avatarUrl: null
  };

  // Security data state
  const S = {
    email: true,
    bio: true,
    tfa: false,
    passAge: '30 hari lalu',
    dev: [
      { id: 1, name: 'iPhone 13 Pro · Perangkat ini', meta: 'Bandung, Indonesia · Aktif sekarang', me: true, icon: '📱' },
      { id: 2, name: 'MacBook Air M2', meta: 'Bandung, Indonesia · 2 jam lalu', me: false, icon: '💻' }
    ]
  };

  // DOM Elements
  const subMain = document.getElementById('subViewProfileMain');
  const subInfo = document.getElementById('subViewInfoPribadi');
  const subSec = document.getElementById('subViewKeamananPrivasi');
  const scrim = document.getElementById('profileScrim');
  const detailsForm = document.getElementById('profileDetailsForm');
  const btnEditTop = document.getElementById('btnEditTopInfoPribadi');

  function getInitials(name) {
    return name.trim().split(/\s+/).slice(0, 2).map(w => w[0]).join('').toUpperCase();
  }

  function formatDobIndo(d) {
    if (!d) return '-';
    try {
      const parts = d.split('-');
      if (parts.length === 3) {
        const dateObj = new Date(parseInt(parts[0], 10), parseInt(parts[1], 10) - 1, parseInt(parts[2], 10));
        return dateObj.toLocaleDateString('id-ID', { day: 'numeric', month: 'long', year: 'numeric' });
      }
      return d;
    } catch (e) {
      return d;
    }
  }

  // 1. RENDER PROFILE
  function renderProfile() {
    const mainShownName = document.getElementById('profileMainShownName');
    const mainShownEmail = document.getElementById('profileMainShownEmail');
    if (mainShownName) mainShownName.textContent = P.name;
    if (mainShownEmail) mainShownEmail.textContent = P.email;

    // Sync Home header avatar & greeting
    const headerAvatar = document.getElementById('headerUserAvatar');
    if (headerAvatar) {
      if (P.avatarUrl) {
        headerAvatar.textContent = '';
        headerAvatar.style.backgroundImage = `url(${P.avatarUrl})`;
        headerAvatar.style.backgroundSize = 'cover';
        headerAvatar.style.backgroundPosition = 'center';
      } else {
        headerAvatar.style.backgroundImage = 'none';
        headerAvatar.textContent = getInitials(P.name);
      }
    }

    const greetingTitle = document.getElementById('greetingUserTitle');
    if (greetingTitle) {
      const firstName = P.name.trim().split(/\s+/)[0] || P.name;
      greetingTitle.textContent = `Selamat pagi, ${firstName} 👋`;
    }

    const mainAvatar = document.getElementById('profileMainAvatar');
    if (mainAvatar) {
      if (P.avatarUrl) {
        mainAvatar.textContent = '';
        mainAvatar.style.backgroundImage = `url(${P.avatarUrl})`;
        mainAvatar.style.backgroundSize = 'cover';
        mainAvatar.style.backgroundPosition = 'center';
      } else {
        mainAvatar.style.backgroundImage = 'none';
        mainAvatar.textContent = getInitials(P.name);
      }
    }

    const infoName = document.getElementById('infoPribadiName');
    const infoSub = document.getElementById('infoPribadiSub');
    if (infoName) infoName.textContent = P.name;
    if (infoSub) infoSub.textContent = `Mahasiswa · ${P.major}`;

    const ringIn = document.getElementById('infoPribadiRingIn');
    if (ringIn) {
      if (P.avatarUrl) {
        ringIn.innerHTML = '';
        ringIn.style.backgroundImage = `url(${P.avatarUrl})`;
        ringIn.style.backgroundSize = 'cover';
        ringIn.style.backgroundPosition = 'center';
      }
    }

    const fieldMap = {
      name: { input: 'inputProfName', textKey: 'name', value: P.name },
      email: { input: 'inputProfEmail', textKey: 'email', value: P.email },
      phone: { input: 'inputProfPhone', textKey: 'phone', value: P.phone },
      dob: { input: 'inputProfDob', textKey: 'dob', value: P.dob, displayVal: formatDobIndo(P.dob) },
      uni: { input: 'inputProfUni', textKey: 'uni', value: P.uni },
      major: { input: 'inputProfMajor', textKey: 'major', value: P.major },
      nim: { input: 'inputProfNim', textKey: 'nim', value: P.nim }
    };

    for (const key in fieldMap) {
      const item = fieldMap[key];
      const inp = document.getElementById(item.input);
      if (inp) inp.value = item.value;
      const valDisplay = document.querySelector(`[data-v="${item.textKey}"]`);
      if (valDisplay) valDisplay.textContent = item.displayVal || item.value || '-';
    }

    const chipsBox = document.getElementById('profileChipsContainer');
    if (chipsBox) {
      chipsBox.innerHTML = '';
      P.chips.forEach((chipText, idx) => {
        const chip = document.createElement('span');
        chip.className = `profile-chip-item k${idx % 4}`;
        chip.textContent = chipText + ' ';

        const delBtn = document.createElement('button');
        delBtn.type = 'button';
        delBtn.className = 'profile-chip-del-btn';
        delBtn.innerHTML = '&times;';
        delBtn.setAttribute('aria-label', `Hapus minat ${chipText}`);
        delBtn.addEventListener('click', (e) => {
          e.stopPropagation();
          P.chips.splice(idx, 1);
          renderProfile();
        });

        chip.appendChild(delBtn);
        chipsBox.appendChild(chip);
      });
    }
  }

  // 2. RENDER SECURITY
  function renderSecurity() {
    const checks = [
      { text: 'Kata sandi kuat', ok: true, weight: 30 },
      { text: 'Email terverifikasi', ok: S.email, weight: 25 },
      { text: S.bio ? 'Login biometrik aktif' : 'Login biometrik belum aktif', ok: S.bio, weight: 30 },
      { text: S.tfa ? 'Verifikasi dua langkah aktif' : 'Verifikasi dua langkah belum diatur', ok: S.tfa, weight: 15 }
    ];

    const score = checks.reduce((sum, item) => sum + (item.ok ? item.weight : 0), 0);
    const isSafe = score >= 85;

    const secTitle = document.getElementById('secHeroTitle');
    const secSub = document.getElementById('secHeroSubtitle');
    const scorePill = document.getElementById('secHeroScorePill');
    const scoreNum = document.getElementById('secScoreNumber');
    const progressFill = document.getElementById('secProgressBarFill');
    const checkList = document.getElementById('secCheckList');
    const passMeta = document.getElementById('secPassAgeText');
    const badge2FA = document.getElementById('secBadge2FA');
    const bioToggle = document.getElementById('secBioToggle');
    const devMeta = document.getElementById('secActiveDevCount');
    const devList = document.getElementById('sheetDevicesContainer');

    if (secTitle) secTitle.textContent = isSafe ? 'Akunmu aman 🔒' : 'Akunmu perlu diperkuat ⚠️';
    if (secSub) secSub.textContent = isSafe ? 'Pemeriksaan utama lolos. Datamu tersimpan dengan aman.' : 'Aktifkan perlindungan tambahan di bawah ini.';
    if (scorePill) {
      scorePill.textContent = `Skor keamanan: ${score}/100`;
      scorePill.classList.toggle('low', !isSafe);
    }
    if (scoreNum) scoreNum.textContent = score;
    if (progressFill) progressFill.style.width = `${score}%`;

    if (checkList) {
      checkList.innerHTML = checks.map(c => `
        <li class="${c.ok ? 'ok' : 'warn'}">
          <span class="profile-ck-point" aria-hidden="true">${c.ok ? '✓' : '!'}</span>${c.text}
        </li>
      `).join('');
    }

    if (passMeta) passMeta.textContent = `Terakhir diubah ${S.passAge}`;

    if (badge2FA) {
      badge2FA.textContent = S.tfa ? 'Aktif' : 'Atur';
      badge2FA.classList.toggle('ok', S.tfa);
    }

    if (bioToggle) {
      bioToggle.setAttribute('aria-checked', S.bio ? 'true' : 'false');
    }

    const tfaSheetToggle = document.getElementById('sheet2FAToggle');
    if (tfaSheetToggle) {
      tfaSheetToggle.setAttribute('aria-checked', S.tfa ? 'true' : 'false');
    }

    if (devMeta) {
      devMeta.textContent = `${S.dev.length} perangkat masuk`;
    }

    if (devList) {
      devList.innerHTML = S.dev.map(d => `
        <div style="display: flex; align-items: center; gap: 14px; padding: 12px 0; border-bottom: 1px solid var(--line, #E6E9F5);">
          <span class="profile-field-icon-box c-purple" style="font-size: 18px;">${d.icon || '📱'}</span>
          <div style="flex: 1;">
            <b style="display: block; font-size: 14.5px; color: var(--color-text-primary, #1B2340);">${d.name}</b>
            <small style="font-size: 12px; color: var(--color-text-secondary, #6B7391);">${d.meta}</small>
          </div>
          ${d.me ? '<span style="font-size: 11.5px; font-weight: 700; color: #2BAE8E; background: #E6F7F2; padding: 3px 8px; border-radius: 8px;">Ini</span>' : `<button class="profile-link-btn btn-remove-device" type="button" data-dev-id="${d.id}" style="color: #E5646B; font-weight: 700; font-size: 13px;">Keluarkan</button>`}
        </div>
      `).join('');
    }
  }

  // 3. SUBVIEW NAVIGATION
  function openSubpage(target) {
    if (subMain) subMain.style.display = 'none';

    if (target === 'info') {
      if (subSec) { subSec.classList.remove('active'); subSec.style.display = 'none'; }
      if (subInfo) { subInfo.classList.add('active'); subInfo.style.display = 'flex'; }
      renderProfile();
    } else if (target === 'security') {
      if (subInfo) { subInfo.classList.remove('active'); subInfo.style.display = 'none'; }
      if (subSec) { subSec.classList.add('active'); subSec.style.display = 'flex'; }
      renderSecurity();
    }

    const scrollContainer = document.querySelector('.app-content-scroll');
    if (scrollContainer) scrollContainer.scrollTop = 0;
  }

  function closeSubpages() {
    setEditMode(false);
    if (subInfo) { subInfo.classList.remove('active'); subInfo.style.display = 'none'; }
    if (subSec) { subSec.classList.remove('active'); subSec.style.display = 'none'; }
    if (subMain) subMain.style.display = 'flex';

    const addRow = document.getElementById('profileAddChipRow');
    if (addRow) addRow.classList.remove('active');

    const scrollContainer = document.querySelector('.app-content-scroll');
    if (scrollContainer) scrollContainer.scrollTop = 0;
  }

  // 4. BOTTOM SHEETS
  function openSheet(sheetEl) {
    if (!sheetEl) return;
    if (scrim) scrim.classList.add('active');
    sheetEl.classList.add('active');
  }

  function closeAllSheets() {
    if (scrim) scrim.classList.remove('active');
    document.querySelectorAll('.profile-bottom-sheet').forEach(s => s.classList.remove('active'));
  }

  // 5. EDIT MODE CONTROLS
  function setEditMode(isEditing) {
    if (!detailsForm) return;
    detailsForm.classList.toggle('profile-form-editing', isEditing);
    if (btnEditTop) btnEditTop.textContent = isEditing ? 'Batal' : 'Edit';

    // Clear errors
    ['errProfName', 'errProfEmail', 'errProfPhone', 'errProfDob'].forEach(id => {
      const errEl = document.getElementById(id);
      if (errEl) errEl.textContent = '';
    });
    detailsForm.querySelectorAll('input').forEach(inp => inp.removeAttribute('aria-invalid'));

    if (isEditing) {
      const nameInput = document.getElementById('inputProfName');
      if (nameInput) nameInput.focus();
    }
  }

  function saveProfile() {
    const nameInp = document.getElementById('inputProfName');
    const emailInp = document.getElementById('inputProfEmail');
    const phoneInp = document.getElementById('inputProfPhone');
    const dobInp = document.getElementById('inputProfDob');
    const uniInp = document.getElementById('inputProfUni');
    const majorInp = document.getElementById('inputProfMajor');
    const nimInp = document.getElementById('inputProfNim');

    const errName = document.getElementById('errProfName');
    const errEmail = document.getElementById('errProfEmail');
    const errPhone = document.getElementById('errProfPhone');

    if (errName) errName.textContent = '';
    if (errEmail) errEmail.textContent = '';
    if (errPhone) errPhone.textContent = '';

    let isValid = true;

    if (!nameInp || !nameInp.value.trim()) {
      if (errName) errName.textContent = 'Nama tidak boleh kosong.';
      if (nameInp) nameInp.setAttribute('aria-invalid', 'true');
      isValid = false;
    }

    if (!emailInp || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailInp.value.trim())) {
      if (errEmail) errEmail.textContent = 'Format email belum benar (contoh: nama@email.com).';
      if (emailInp) emailInp.setAttribute('aria-invalid', 'true');
      isValid = false;
    }

    if (!phoneInp || !/^\+?[0-9\s–-]{8,20}$/.test(phoneInp.value.trim())) {
      if (errPhone) errPhone.textContent = 'Nomor telepon belum benar (contoh: +62 812-3456-7890).';
      if (phoneInp) phoneInp.setAttribute('aria-invalid', 'true');
      isValid = false;
    }

    if (!isValid) return;

    // Apply values
    P.name = nameInp.value.trim();
    P.email = emailInp.value.trim();
    P.phone = phoneInp.value.trim();
    if (dobInp) P.dob = dobInp.value;
    if (uniInp) P.uni = uniInp.value.trim();
    if (majorInp) P.major = majorInp.value.trim();
    if (nimInp) P.nim = nimInp.value.trim();

    renderProfile();
    setEditMode(false);
    showNotification('Perubahan profil berhasil disimpan! ✨');
  }

  // 6. EVENT LISTENERS SETUP

  // Navigation triggers
  const btnEditTopMain = document.getElementById('btnOpenEditProfileTop');
  const btnMenuPengaturan = document.getElementById('btnMenuPengaturanProfil');
  const btnMenuKeamanan = document.getElementById('btnMenuKeamananPrivasi');
  const btnLogoutTrigger = document.getElementById('btnTriggerLogout');

  if (btnEditTopMain) btnEditTopMain.addEventListener('click', () => openSubpage('info'));
  if (btnMenuPengaturan) btnMenuPengaturan.addEventListener('click', () => openSubpage('info'));
  if (btnMenuKeamanan) btnMenuKeamanan.addEventListener('click', () => openSubpage('security'));
  if (btnLogoutTrigger) {
    btnLogoutTrigger.addEventListener('click', () => {
      openSheet(document.getElementById('sheetLogoutConfirm'));
    });
  }

  // Back buttons
  const btnBackInfo = document.getElementById('btnBackFromInfoPribadi');
  const btnBackSec = document.getElementById('btnBackFromKeamanan');
  if (btnBackInfo) btnBackInfo.addEventListener('click', closeSubpages);
  if (btnBackSec) btnBackSec.addEventListener('click', closeSubpages);

  // Edit triggers in Info Pribadi
  if (btnEditTop) {
    btnEditTop.addEventListener('click', () => {
      if (detailsForm && detailsForm.classList.contains('profile-form-editing')) {
        setEditMode(false);
        renderProfile();
      } else {
        setEditMode(true);
      }
    });
  }

  document.querySelectorAll('.btn-trigger-edit-fields').forEach(btn => {
    btn.addEventListener('click', () => setEditMode(true));
  });

  const btnSaveBottom = document.getElementById('btnSaveAllProfileDetails');
  const btnCancelBottom = document.getElementById('btnCancelAllProfileDetails');
  if (btnSaveBottom) btnSaveBottom.addEventListener('click', saveProfile);
  if (btnCancelBottom) {
    btnCancelBottom.addEventListener('click', () => {
      setEditMode(false);
      renderProfile();
    });
  }

  // File Upload for Avatar
  const fileInput = document.getElementById('profileFileInput');
  const camTriggers = ['btnChangePhotoLink', 'btnInfoPribadiCam', 'btnMainAvatarCam'];
  camTriggers.forEach(id => {
    const el = document.getElementById(id);
    if (el && fileInput) {
      el.addEventListener('click', (e) => {
        e.preventDefault();
        fileInput.click();
      });
    }
  });

  if (fileInput) {
    fileInput.addEventListener('change', (e) => {
      const file = e.target.files && e.target.files[0];
      if (!file) return;

      if (file.size > 5 * 1024 * 1024) {
        showNotification('Ukuran foto maksimal 5 MB.');
        return;
      }

      const reader = new FileReader();
      reader.onload = (loadEvt) => {
        P.avatarUrl = loadEvt.target.result;
        renderProfile();
        showNotification('Foto profil berhasil diperbarui! 📸');
      };
      reader.readAsDataURL(file);
    });
  }

  // Interest Chips
  const btnToggleChip = document.getElementById('btnToggleAddChip');
  const addChipRow = document.getElementById('profileAddChipRow');
  const inputNewChip = document.getElementById('inputNewChipText');
  const btnAddChip = document.getElementById('btnAddChipSubmit');

  if (btnToggleChip && addChipRow) {
    btnToggleChip.addEventListener('click', () => {
      addChipRow.classList.toggle('active');
      if (addChipRow.classList.contains('active') && inputNewChip) {
        inputNewChip.focus();
      }
    });
  }

  function handleAddChip() {
    if (!inputNewChip) return;
    const val = inputNewChip.value.trim();
    if (!val) return;

    if (P.chips.length >= 12) {
      showNotification('Maksimal 12 minat');
      return;
    }

    if (P.chips.includes(val)) {
      showNotification('Minat tersebut sudah ada.');
      return;
    }

    P.chips.push(val);
    inputNewChip.value = '';
    renderProfile();
    showNotification('Minat baru ditambahkan! ✨');
    inputNewChip.focus();
  }

  if (btnAddChip) btnAddChip.addEventListener('click', handleAddChip);
  if (inputNewChip) {
    inputNewChip.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
        handleAddChip();
      }
    });
  }

  // Security Switches & Sheets
  const bioToggle = document.getElementById('secBioToggle');
  if (bioToggle) {
    bioToggle.addEventListener('click', () => {
      S.bio = !S.bio;
      renderSecurity();
      showNotification(S.bio ? 'Login biometrik aktif! 👆' : 'Login biometrik dinonaktifkan.');
    });
  }

  const btnOpenPass = document.getElementById('btnOpenSheetPass');
  if (btnOpenPass) {
    btnOpenPass.addEventListener('click', () => {
      openSheet(document.getElementById('sheetUbahSandi'));
    });
  }

  const btnOpen2FA = document.getElementById('btnOpenSheet2FA');
  if (btnOpen2FA) {
    btnOpen2FA.addEventListener('click', () => {
      openSheet(document.getElementById('sheetDuaLangkah'));
    });
  }

  const sheet2FAToggle = document.getElementById('sheet2FAToggle');
  if (sheet2FAToggle) {
    sheet2FAToggle.addEventListener('click', () => {
      S.tfa = !S.tfa;
      renderSecurity();
      showNotification(S.tfa ? 'Verifikasi dua langkah aktif! 🛡️' : 'Verifikasi dua langkah dinonaktifkan.');
    });
  }

  const btnOpenDev = document.getElementById('btnOpenSheetDev');
  if (btnOpenDev) {
    btnOpenDev.addEventListener('click', () => {
      openSheet(document.getElementById('sheetSesiAktif'));
    });
  }

  const sheetDevicesContainer = document.getElementById('sheetDevicesContainer');
  if (sheetDevicesContainer) {
    sheetDevicesContainer.addEventListener('click', (e) => {
      const removeBtn = e.target.closest('.btn-remove-device');
      if (!removeBtn) return;
      const devId = parseInt(removeBtn.getAttribute('data-dev-id'), 10);
      S.dev = S.dev.filter(d => d.id !== devId);
      renderSecurity();
      showNotification('Perangkat berhasil dikeluarkan! 👋');
    });
  }

  // Danger zone sheets
  const btnOpenDeact = document.getElementById('btnOpenSheetDeact');
  if (btnOpenDeact) {
    btnOpenDeact.addEventListener('click', () => {
      openSheet(document.getElementById('sheetNonaktifkanAkun'));
    });
  }

  const btnConfirmDeactivate = document.getElementById('btnConfirmDeactivate');
  if (btnConfirmDeactivate) {
    btnConfirmDeactivate.addEventListener('click', () => {
      closeAllSheets();
      closeSubpages();
      showNotification('Akunmu dinonaktifkan sementara.');
    });
  }

  const btnOpenDel = document.getElementById('btnOpenSheetDelete');
  if (btnOpenDel) {
    btnOpenDel.addEventListener('click', () => {
      const confirmInput = document.getElementById('inputConfirmDeleteText');
      const confirmBtn = document.getElementById('btnConfirmDeleteAccount');
      if (confirmInput) confirmInput.value = '';
      if (confirmBtn) confirmBtn.disabled = true;
      openSheet(document.getElementById('sheetHapusAkun'));
    });
  }

  const inputConfirmDelete = document.getElementById('inputConfirmDeleteText');
  const btnConfirmDelete = document.getElementById('btnConfirmDeleteAccount');
  if (inputConfirmDelete && btnConfirmDelete) {
    inputConfirmDelete.addEventListener('input', (e) => {
      btnConfirmDelete.disabled = (e.target.value.trim().toUpperCase() !== 'HAPUS');
    });
  }

  if (btnConfirmDelete) {
    btnConfirmDelete.addEventListener('click', () => {
      closeAllSheets();
      closeSubpages();
      showNotification('Akun dan seluruh datamu telah dihapus permanen.');
    });
  }

  // Logout confirm
  const btnConfirmLogout = document.getElementById('btnConfirmLogout');
  if (btnConfirmLogout) {
    btnConfirmLogout.addEventListener('click', () => {
      closeAllSheets();
      showNotification('Berhasil keluar dari akun. Sampai jumpa!');
    });
  }

  // Password sheet submit
  const btnSubmitPass = document.getElementById('btnSubmitNewPass');
  if (btnSubmitPass) {
    btnSubmitPass.addEventListener('click', () => {
      const oldPass = document.getElementById('inputSheetOldPass');
      const newPass = document.getElementById('inputSheetNewPass');
      const repPass = document.getElementById('inputSheetRepeatPass');
      const errEl = document.getElementById('errSheetPass');

      if (errEl) errEl.textContent = '';
      [oldPass, newPass, repPass].forEach(p => p && p.removeAttribute('aria-invalid'));

      if (!oldPass || !oldPass.value) {
        if (errEl) errEl.textContent = 'Isi kata sandi saat ini dulu.';
        if (oldPass) oldPass.setAttribute('aria-invalid', 'true');
        return;
      }

      if (!newPass || newPass.value.length < 8) {
        if (errEl) errEl.textContent = 'Kata sandi baru minimal 8 karakter.';
        if (newPass) newPass.setAttribute('aria-invalid', 'true');
        return;
      }

      if (newPass.value === oldPass.value) {
        if (errEl) errEl.textContent = 'Kata sandi baru harus berbeda dari yang lama.';
        if (newPass) newPass.setAttribute('aria-invalid', 'true');
        return;
      }

      if (!repPass || repPass.value !== newPass.value) {
        if (errEl) errEl.textContent = 'Ulangi kata sandi harus sama dengan kata sandi baru.';
        if (repPass) repPass.setAttribute('aria-invalid', 'true');
        return;
      }

      oldPass.value = '';
      newPass.value = '';
      repPass.value = '';
      S.passAge = 'baru saja';
      renderSecurity();
      closeAllSheets();
      showNotification('Kata sandi berhasil diperbarui! 🔒');
    });
  }

  // Eye toggle for password inputs
  document.querySelectorAll('.btn-toggle-eye').forEach(btn => {
    btn.addEventListener('click', () => {
      const inputId = btn.getAttribute('data-eye');
      const inp = document.getElementById(inputId);
      if (!inp) return;
      const isPass = inp.type === 'password';
      inp.type = isPass ? 'text' : 'password';
      btn.textContent = isPass ? 'Sembunyi' : 'Lihat';
    });
  });

  // Sheet close buttons & scrim
  if (scrim) scrim.addEventListener('click', closeAllSheets);
  document.querySelectorAll('.btn-close-profile-sheet').forEach(btn => {
    btn.addEventListener('click', closeAllSheets);
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      const anyActiveSheet = document.querySelector('.profile-bottom-sheet.active');
      if (anyActiveSheet) {
        closeAllSheets();
      } else if (subInfo && subInfo.classList.contains('active')) {
        closeSubpages();
      } else if (subSec && subSec.classList.contains('active')) {
        closeSubpages();
      }
    }
  });

  // Initial renders
  renderProfile();
  renderSecurity();
}

/* -------------------------------------------------------------------------- */
/* 9. NOTIFICATION TOAST                                                      */
/* -------------------------------------------------------------------------- */
function initNotificationToast() {
  const notifBtn = document.getElementById('notificationBtn');
  if (notifBtn) {
    notifBtn.addEventListener('click', () => {
      showNotification('📌 1 tugas deadline mendekat: Tugas Web Development (23:59 WIB)');
    });
  }
}

function showNotification(message) {
  let toast = document.getElementById('serenaToast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'serenaToast';
    toast.style.position = 'absolute';
    toast.style.top = '60px';
    toast.style.left = '50%';
    toast.style.transform = 'translateX(-50%) translateY(-20px)';
    toast.style.width = 'calc(100% - 40px)';
    toast.style.maxWidth = '350px';
    toast.style.padding = '12px 16px';
    toast.style.background = 'rgba(27, 35, 64, 0.94)';
    toast.style.color = '#ffffff';
    toast.style.borderRadius = '16px';
    toast.style.fontSize = '12.5px';
    toast.style.fontWeight = '600';
    toast.style.lineHeight = '1.4';
    toast.style.boxShadow = '0 10px 25px rgba(0,0,0,0.2)';
    toast.style.zIndex = '100';
    toast.style.opacity = '0';
    toast.style.transition = 'all 0.3s cubic-bezier(0.16, 1, 0.3, 1)';
    toast.style.pointerEvents = 'none';

    const frame = document.querySelector('.serena-app-frame');
    if (frame) frame.appendChild(toast);
  }

  toast.textContent = message;
  toast.style.opacity = '1';
  toast.style.transform = 'translateX(-50%) translateY(0)';

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(-50%) translateY(-10px)';
  }, 3500);
}
