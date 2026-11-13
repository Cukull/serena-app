/**
 * SERENA APP - CORE INTERACTIVE CONTROLLER
 * Menangani interaksi Home, Detail Tugas, Detail Jadwal, dan Statistik (Harian/Mingguan/Bulanan).
 */

document.addEventListener('DOMContentLoaded', () => {
  initClock();
  initFocusTimer();
  initTabNavigation();
  initHomeCardNavigation();
  initStatistikControls();
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
/* 2. FOCUS TIMER CONTROLS                                                    */
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
    if (isRunning) {
      pauseBtnLabel.textContent = 'Jeda Fokus';
      focusStatusText.textContent = 'Sedang fokus';
      pulseDot.style.backgroundColor = 'var(--color-success)';
      pulseDot.style.animationPlayState = 'running';
      pauseBtnIcon.innerHTML = `
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="3" stroke-linecap="round">
          <line x1="10" y1="5" x2="10" y2="19"></line>
          <line x1="14" y1="5" x2="14" y2="19"></line>
        </svg>
      `;
    } else {
      pauseBtnLabel.textContent = 'Lanjutkan';
      focusStatusText.textContent = 'Sesi terjeda';
      pulseDot.style.backgroundColor = '#F59E0B';
      pulseDot.style.animationPlayState = 'paused';
      pauseBtnIcon.innerHTML = `
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
          <polygon points="5 3 19 12 5 21 5 3" fill="#ffffff"></polygon>
        </svg>
      `;
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

  startTimer();
}

/* -------------------------------------------------------------------------- */
/* 3. VIEW ROUTER & CARD NAVIGATION                                           */
/* -------------------------------------------------------------------------- */
let activeView = 'home';

function switchView(viewName) {
  const views = {
    home: document.getElementById('viewHome'),
    detailTugas: document.getElementById('viewDetailTugas'),
    detailJadwal: document.getElementById('viewDetailJadwal'),
    statistik: document.getElementById('viewStatistik'),
    generic: document.getElementById('viewGeneric')
  };

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

  // Scroll viewport to top smoothly
  if (scrollContainer) {
    scrollContainer.scrollTop = 0;
  }

  // In detail/statistik views, header is simplified or contextual
  if (viewName === 'home') {
    if (header) header.style.display = 'flex';
    if (bottomNav) bottomNav.style.display = 'flex';
    setBottomNavActive('home');
  } else if (viewName === 'statistik' || viewName === 'detailTugas' || viewName === 'detailJadwal') {
    if (header) header.style.display = 'none'; // Contextual top bar inside component
    if (bottomNav) bottomNav.style.display = 'flex';
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

function initHomeCardNavigation() {
  // A. Klik Tenggat Terdekat -> Ke Detail Tugas
  const deadlineCard = document.getElementById('deadlineCard');
  if (deadlineCard) {
    deadlineCard.style.cursor = 'pointer';
    deadlineCard.addEventListener('click', () => {
      switchView('detailTugas');
    });
  }

  // B. Klik Agenda Tugas -> Ke Detail Tugas
  const agendaTugasItem = document.getElementById('agendaTugasItem');
  if (agendaTugasItem) {
    agendaTugasItem.style.cursor = 'pointer';
    agendaTugasItem.addEventListener('click', () => {
      switchView('detailTugas');
    });
  }

  // C. Klik Agenda Kuliah UI/UX -> Ke Detail Jadwal Kuliah
  const agendaKuliahItem = document.getElementById('agendaKuliahItem');
  if (agendaKuliahItem) {
    agendaKuliahItem.style.cursor = 'pointer';
    agendaKuliahItem.addEventListener('click', () => {
      switchView('detailJadwal');
    });
  }

  // D. Klik Linked Task di dalam Detail Jadwal -> Ke Detail Tugas
  const linkedTugasItem = document.getElementById('linkedTugasItem');
  if (linkedTugasItem) {
    linkedTugasItem.addEventListener('click', () => {
      switchView('detailTugas');
    });
  }

  // E. Klik Statistik Harian (Header atau Kartu) -> Ke Halaman Statistik
  const headerStatistikHarian = document.getElementById('headerStatistikHarian');
  if (headerStatistikHarian) {
    headerStatistikHarian.style.cursor = 'pointer';
    headerStatistikHarian.addEventListener('click', () => {
      switchView('statistik');
    });
  }

  const statCards = document.querySelectorAll('.stat-card');
  statCards.forEach((card, index) => {
    card.style.cursor = 'pointer';
    card.addEventListener('click', () => {
      switchView('statistik');
      // If user clicked a specific stat card, activate corresponding metric tab!
      const metrics = ['tasks', 'focus', 'done'];
      setStatMetric(metrics[index] || 'tasks');
    });
  });

  // F. Tombol Kembali
  const btnTugasKembali = document.getElementById('btnTugasKembali');
  if (btnTugasKembali) {
    btnTugasKembali.addEventListener('click', () => {
      switchView('home');
    });
  }

  const btnJadwalKembali = document.getElementById('btnJadwalKembali');
  if (btnJadwalKembali) {
    btnJadwalKembali.addEventListener('click', () => {
      switchView('home');
    });
  }

  const btnStatBack = document.getElementById('btnStatBack');
  if (btnStatBack) {
    btnStatBack.addEventListener('click', () => {
      switchView('home');
    });
  }

  const btnTugasLihat = document.getElementById('btnTugasLihat');
  if (btnTugasLihat) {
    btnTugasLihat.addEventListener('click', () => {
      showNotification('🚀 Membuka link pengumpulan LMS...');
    });
  }
}

/* -------------------------------------------------------------------------- */
/* 4. STATISTIK TAB & PERIOD SWITCHER (HARIAN, MINGGUAN, BULANAN)             */
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
/* 5. BOTTOM NAVIGATION TAB SWITCHING                                         */
/* -------------------------------------------------------------------------- */
function initTabNavigation() {
  const tabs = document.querySelectorAll('.nav-tab-item');
  const genericTitle = document.getElementById('genericViewTitle');
  const genericDesc = document.getElementById('genericViewDesc');

  tabs.forEach(tab => {
    tab.addEventListener('click', (e) => {
      e.preventDefault();
      const targetTab = tab.getAttribute('data-tab');

      if (targetTab === 'home') {
        switchView('home');
      } else {
        switchView('generic');
        setBottomNavActive(targetTab);
        const titles = {
          jadwal: 'Jadwal Kuliah & Planner',
          fokus: 'Mode Sesi Fokus',
          akun: 'Pengaturan & Akun'
        };
        const descs = {
          jadwal: 'Kelola agenda mingguan, kalender akademik, dan daftar tugas kuliah.',
          fokus: 'Pilih mode Pomodoro, Deep Focus, atau Exam Mode untuk belajar optimal.',
          akun: 'Profil mahasiswa, streak belajar, pencapaian, dan kustomisasi notifikasi.'
        };
        if (genericTitle) genericTitle.textContent = titles[targetTab] || 'Serena';
        if (genericDesc) genericDesc.textContent = descs[targetTab] || 'Halaman sedang disiapkan.';
      }
    });
  });
}

/* -------------------------------------------------------------------------- */
/* 6. NOTIFICATION TOAST                                                      */
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
