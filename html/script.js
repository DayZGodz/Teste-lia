let categories = [];
let activeStates = {};
let currentCategory = null;

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'open') {
        categories = data.config;
        document.body.classList.remove('hidden');
        renderMainMenu();
    } else if (data.action === 'close') {
        document.body.classList.add('hidden');
        fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' });
    } else if (data.action === 'updateState') {
        // key format: "catIndex-itemIndex"
        activeStates[data.key] = data.state;
        if (currentCategory !== null) {
            renderCategory(currentCategory);
        }
    }
});

function renderMainMenu() {
    currentCategory = null;
    const list = document.getElementById('button-list');
    const title = document.getElementById('title');
    const controls = document.getElementById('controls');
    
    list.innerHTML = '';
    title.innerText = 'PAINEL DE EFEITOS';
    controls.classList.add('hidden');

    categories.forEach((cat, index) => {
        const btn = document.createElement('div');
        btn.className = 'button';
        btn.innerText = cat.Label;
        btn.onclick = () => {
            currentCategory = index;
            renderCategory(index);
        };
        list.appendChild(btn);
    });
}

function renderCategory(index) {
    const cat = categories[index];
    const list = document.getElementById('button-list');
    const title = document.getElementById('title');
    const controls = document.getElementById('controls');

    list.innerHTML = '';
    title.innerText = cat.Label;
    controls.classList.remove('hidden');

    // Add STOP button if configured
    if (cat.ShowStop) {
        const stopBtn = document.createElement('div');
        stopBtn.className = 'button';
        stopBtn.innerText = 'STOP ALL';
        stopBtn.style.background = '#550000';
        stopBtn.style.borderColor = '#ff3333';
        stopBtn.onclick = () => {
            fetch(`https://${GetParentResourceName()}/stopCategory`, {
                method: 'POST',
                body: JSON.stringify({ category: index })
            });
        };
        list.appendChild(stopBtn);
        
        // Add separator
        const sep = document.createElement('div');
        sep.style.height = '4px';
        list.appendChild(sep);
    }

    cat.Items.forEach((item, itemIndex) => {
        const btn = document.createElement('div');
        btn.className = 'button';
        btn.innerText = item.Label;
        
        const key = `${index}-${itemIndex}`;
        if (activeStates[key]) {
            btn.classList.add('active');
        }

        // Logic based on Interaction mode
        if (cat.Interaction === 'hold') {
            // MOUSE - Segurar para ativar, soltar para parar
            btn.onmousedown = () => triggerState(index, itemIndex, true);
            btn.onmouseup = () => triggerState(index, itemIndex, false);
            btn.onmouseleave = () => {
                // Para quando o mouse sair do botão
                 triggerState(index, itemIndex, false);
            };

            // TOUCH (for completeness, though usually FiveM is mouse)
            // Prevent default to avoid scrolling/clicking issues
            btn.ontouchstart = (e) => { e.preventDefault(); triggerState(index, itemIndex, true); };
            btn.ontouchend = (e) => { e.preventDefault(); triggerState(index, itemIndex, false); };

        } else {
            // FIREWORKS - Um clique inicia e continua até STOP ALL
            btn.onclick = () => {
                // Inicia o efeito (sempre ativa, não faz toggle)
                triggerState(index, itemIndex, true);
            };
        }

        list.appendChild(btn);
    });
}

function triggerState(catIndex, itemIndex, state) {
    fetch(`https://${GetParentResourceName()}/setState`, {
        method: 'POST',
        body: JSON.stringify({
            category: catIndex,
            item: itemIndex,
            state: state
        })
    });
}

function goBack() {
    renderMainMenu();
}

document.onkeyup = function(data) {
    if (data.key === 'Escape') {
        document.body.classList.add('hidden');
        fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' });
    }
};
