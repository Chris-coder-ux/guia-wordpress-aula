/* ============================================================
   IFCT0510 — JS compartido (SRP)
   Progreso, tamaño de letra, botón copiar, impresión y rail activo.
   Cada módulo debe definir window.IFCT0510 ANTES de cargar este script:
     window.IFCT0510 = {
       key: 'ifct0510-<modulo>-progress.v1',
       fontKey: 'ifct0510-<modulo>-font.v1',
       total: <número de pasos>,
       sizes: ['100%','112.5%','125%','137.5%']
     };
   ============================================================ */
(function(){
  'use strict';

  var cfg = window.IFCT0510 || {};
  var KEY = cfg.key || 'ifct0510-progress.v1';
  var FONTKEY = cfg.fontKey || 'ifct0510-font.v1';
  var SIZES = cfg.sizes || ['100%','112.5%','125%','137.5%'];

  var boxes = Array.prototype.slice.call(document.querySelectorAll('[data-done]'));
  var total = boxes.length;
  var done = new Set();

  function loadDone(){
    try{
      var raw = localStorage.getItem(KEY);
      if(raw){
        JSON.parse(raw).forEach(function(v){ done.add(String(v)); });
      }
    }catch(e){}
  }
  function save(){
    try{
      localStorage.setItem(KEY, JSON.stringify(Array.from(done)));
    }catch(e){}
  }
  function announce(msg){
    var live = document.getElementById('live');
    if(live) live.textContent = msg;
  }
  function render(){
    boxes.forEach(function(b){
      var id = b.getAttribute('data-done');
      var on = done.has(id);
      b.checked = on;
      var step = b.closest('.step');
      if(step) step.classList.toggle('is-done', on);
    });

    var n = done.size;
    var count = document.getElementById('count');
    var bar = document.getElementById('bar');
    if(count) count.textContent = String(n);
    if(bar) bar.style.width = (total ? (n / total * 100) : 0) + '%';

    var fill = document.getElementById('rail-fill');
    if(fill){
      fill.style.height = (total && n > 0)
        ? ('calc(' + (n / total * 100) + '% - .9rem)')
        : '0';
    }

    Array.prototype.forEach.call(document.querySelectorAll('.rail a[data-target]'), function(a){
      var t = a.getAttribute('data-target');
      a.classList.toggle('is-done', done.has(t));
      if(cfg.total){
        a.classList.toggle('is-current', t === String(n + 1));
      }
    });

    var totalSpan = document.getElementById('total');
    if(totalSpan) totalSpan.textContent = String(total);

    var msg = document.getElementById('final-msg');
    if(msg) msg.hidden = (n !== total);

    var title = document.getElementById('final-title');
    if(title){
      title.textContent = (n === total && total > 0)
        ? '¡Tarea terminada!'
        : 'Chuleta: direcciones y atajos';
    }

    var finalEl = document.querySelector('.final');
    if(finalEl){
      if(n === total && total > 0){
        finalEl.classList.add('all-done');
      } else {
        finalEl.classList.remove('all-done');
      }
    }

    document.body.classList.toggle('all-done', n === total && total > 0);
  }

  loadDone();

  boxes.forEach(function(b){
    b.addEventListener('change', function(){
      var id = b.getAttribute('data-done');
      if(b.checked){
        done.add(id);
        announce('Paso ' + id + ' marcado como hecho.');
      } else {
        done.delete(id);
        announce('Paso ' + id + ' desmarcado.');
      }
      save();
      render();
    });
  });

  var countEl = document.getElementById('total');
  if(countEl) countEl.textContent = String(total);

  var reset = document.getElementById('reset');
  if(reset){
    reset.addEventListener('click', function(){
      if(!confirm('¿Borrar las marcas de todos los pasos? No se puede deshacer.')) return;
      done.clear();
      save();
      render();
      announce('Progreso borrado.');
    });
  }

  var printBtn = document.getElementById('print-btn');
  if(printBtn){
    printBtn.addEventListener('click', function(){
      window.print();
    });
  }

  window.addEventListener('beforeprint', function(){
    Array.prototype.forEach.call(document.querySelectorAll('details'), function(d){
      d.setAttribute('data-was-open', d.open ? '1' : '0');
      d.open = true;
    });
  });
  window.addEventListener('afterprint', function(){
    Array.prototype.forEach.call(document.querySelectorAll('details'), function(d){
      if(d.getAttribute('data-was-open') === '0') d.open = false;
    });
  });

  // ---------- tamaño de letra ----------
  var idx = 0;
  try{
    idx = parseInt(localStorage.getItem(FONTKEY) || '0', 10) || 0;
  }catch(e){}
  if(idx < 0 || idx >= SIZES.length) idx = 0;

  function applyFont(){
    document.documentElement.style.fontSize = SIZES[idx];
    try{
      localStorage.setItem(FONTKEY, String(idx));
    }catch(e){}
  }
  applyFont();

  var fp = document.getElementById('font-plus');
  var fm = document.getElementById('font-minus');
  if(fp){
    fp.addEventListener('click', function(){
      idx = Math.min(SIZES.length - 1, idx + 1);
      applyFont();
      announce('Letra más grande.');
    });
  }
  if(fm){
    fm.addEventListener('click', function(){
      idx = Math.max(0, idx - 1);
      applyFont();
      announce('Letra más pequeña.');
    });
  }

  // ---------- botón copiar ----------
  function legacyCopy(text){
    var ta = document.createElement('textarea');
    ta.value = text;
    ta.setAttribute('readonly', '');
    ta.style.position = 'fixed';
    ta.style.top = '-1000px';
    document.body.appendChild(ta);
    ta.select();
    var ok = false;
    try{
      ok = document.execCommand('copy');
    }catch(e){
      ok = false;
    }
    document.body.removeChild(ta);
    return ok;
  }

  document.addEventListener('click', function(ev){
    var btn = ev.target.closest('[data-copy]');
    if(!btn) return;
    var text = btn.getAttribute('data-copy');
    var span = btn.querySelector('span');
    var previous = span ? span.textContent : btn.textContent;

    var finish = function(ok){
      btn.classList.add('copied');
      if(span){
        span.textContent = ok ? '¡Copiado!' : previous;
      } else {
        btn.textContent = '¡Copiado!';
      }
      announce(ok ? 'Dirección copiada al portapapeles.' : 'No se pudo copiar. Selecciona el texto a mano.');
      window.setTimeout(function(){
        btn.classList.remove('copied');
        if(span){
          span.textContent = previous;
        } else {
          btn.textContent = previous;
        }
      }, 1800);
    };

    if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(text)
        .then(function(){ finish(true); }, function(){ finish(legacyCopy(text)); });
    } else {
      finish(legacyCopy(text));
    }
  });

  // ---------- rail activo (IntersectionObserver) ----------
  if('IntersectionObserver' in window){
    var steps = Array.prototype.slice.call(document.querySelectorAll('.step'));
    var io = new IntersectionObserver(function(entries){
      entries.forEach(function(en){
        if(!en.isIntersecting) return;
        var id = en.target.id;
        Array.prototype.forEach.call(document.querySelectorAll('.rail a'), function(a){
          a.classList.toggle('is-current', a.getAttribute('href') === '#' + id);
        });
      });
    }, { rootMargin: '-30% 0px -55% 0px', threshold: 0 });
    steps.forEach(function(s){ io.observe(s); });
  }

  render();
})();
