let currentStats = null;
let currentLevels = null;

// Mise à jour de l'heure dans la tablette
function updateTime() {
    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    $('#tabletTime').text(`${hours}:${minutes}`);
}

setInterval(updateTime, 1000);

// Écouter les messages NUI
window.addEventListener('message', (event) => {
    const data = event.data;

    switch(data.action) {
        case 'openLab':
            openLab(data.alcoholTypes, data.levels);
            break;
        case 'closeLab':
            $('#lab-menu').addClass('hidden');
            break;
        case 'showReceipt':
            showReceipt(data.items, data.total);
            break;
        case 'openTablet':
            openTablet(data.stats, data.levels);
            break;
        case 'closeAll':
            closeAll();
            break;
        case 'showHelpText':
            showHelpText(data.text, data.key);
            break;
        case 'hideHelpText':
            hideHelpText();
            break;
    }
});

// Afficher le texte d'aide
function showHelpText(text, key) {
    $('#helpKey').text(key || 'E');
    $('#helpMessage').text(text);
    $('#help-text').removeClass('hidden');
}

// Cacher le texte d'aide
function hideHelpText() {
    $('#help-text').addClass('hidden');
}

// Ouvrir le menu du laboratoire
function openLab(alcoholTypes, levels) {
    const alcoholList = $('#alcoholList');
    alcoholList.empty();

    alcoholTypes.forEach(alcohol => {
        const isLocked = false; // À déterminer selon le niveau du joueur

        const alcoholCard = $(`
            <div class="alcohol-item ${isLocked ? 'locked' : ''}">
                <div class="alcohol-header">
                    <div class="alcohol-name">
                        <i class="fas fa-bottle-droplet"></i>
                        ${alcohol.name}
                        ${isLocked ? '<i class="fas fa-lock lock-icon"></i>' : ''}
                    </div>
                </div>
                <div class="quality-buttons" data-alcohol="${alcohol.name}">
                    ${alcohol.qualities.map(quality => `
                        <button class="quality-btn ${quality.quality === 'mauvaise' ? 'low' : quality.quality === 'moyenne' ? 'mid' : 'high'}"
                                data-quality="${quality.quality}">
                            <div>${capitalizeFirst(quality.quality)}</div>
                            <div class="quality-info">${quality.sellPrice}$ • ${alcohol.distillationTime / 1000}s</div>
                        </button>
                    `).join('')}
                </div>
                <div class="ingredients">
                    ${Object.entries(alcohol.qualities[0].ingredients).map(([item, count]) => `
                        <div class="ingredient">
                            <i class="fas fa-seedling"></i>
                            ${formatItemName(item)} x${count}
                        </div>
                    `).join('')}
                </div>
            </div>
        `);

        alcoholList.append(alcoholCard);
    });

    // Event listeners pour les boutons de qualité
    $('.quality-btn').on('click', function() {
        const alcoholType = $(this).closest('.quality-buttons').data('alcohol');
        const quality = $(this).data('quality');
        processAlcohol(alcoholType, quality);
    });

    $('#lab-menu').removeClass('hidden');
}

// Traiter l'alcool
function processAlcohol(alcoholType, quality) {
    $.post(`https://${GetParentResourceName()}/processAlcohol`, JSON.stringify({
        alcoholType: alcoholType,
        quality: quality
    }), (response) => {
        if (response.success) {
            // Succès géré côté client
        } else {
            console.error('Erreur:', response.message);
        }
    });
}

// Afficher le reçu de vente
function showReceipt(items, total) {
    const receiptItems = $('#receiptItems');
    receiptItems.empty();

    items.forEach(item => {
        const itemCard = $(`
            <div class="receipt-item">
                <div class="receipt-item-info">
                    <div class="receipt-item-name">${item.name}</div>
                    <div class="receipt-item-details">${item.count}x • ${formatMoney(item.price)} chacun</div>
                </div>
                <div class="receipt-item-total">${formatMoney(item.total)}</div>
            </div>
        `);
        receiptItems.append(itemCard);
    });

    $('#receiptTotal').text(formatMoney(total));
    $('#receipt-menu').removeClass('hidden');
}

// Ouvrir la tablette
function openTablet(stats, levels) {
    currentStats = stats;
    currentLevels = levels;

    // Mettre à jour les stats principales
    $('#statLevel').text(stats.level);
    $('#statExp').text(stats.experience);
    $('#statFarmed').text(stats.total_farmed);
    $('#statProcessed').text(stats.total_processed);
    $('#statSold').text(stats.total_sold);
    $('#statMoney').text(formatMoney(stats.money_earned));

    // Items farmés
    const farmedItems = $('#farmedItems');
    farmedItems.empty();

    if (Object.keys(stats.farmed_items).length === 0) {
        farmedItems.append(`
            <div style="color: rgba(255,255,255,0.5); text-align: center; padding: 20px;">
                Aucun item farmé pour le moment
            </div>
        `);
    } else {
        Object.entries(stats.farmed_items).forEach(([item, count]) => {
            const itemCard = $(`
                <div class="farmed-item">
                    <div class="farmed-item-name">${formatItemName(item)}</div>
                    <div class="farmed-item-count">${count}</div>
                </div>
            `);
            farmedItems.append(itemCard);
        });
    }

    // Niveaux et recettes
    const levelsList = $('#levelsList');
    levelsList.empty();

    levels.forEach((level, index) => {
        const isUnlocked = stats.level >= index;
        const isCurrent = stats.level === index;

        const levelCard = $(`
            <div class="level-item ${isUnlocked ? 'unlocked' : ''} ${isCurrent ? 'current' : ''}">
                <div class="level-header">
                    <div class="level-name">
                        <i class="fas ${isUnlocked ? 'fa-check-circle' : 'fa-lock'}"></i>
                        Niveau ${index} - ${level.name}
                    </div>
                    <div class="level-badge ${isUnlocked ? 'unlocked' : 'locked'} ${isCurrent ? 'current' : ''}">
                        ${isUnlocked ? (isCurrent ? 'Actuel' : 'Débloqué') : `Requis: ${level.level} XP`}
                    </div>
                </div>
                <div class="level-recipes">
                    ${level.recipes.map(recipe => `
                        <div class="recipe-tag">
                            <i class="fas fa-bottle-droplet"></i>
                            ${recipe}
                        </div>
                    `).join('')}
                </div>
            </div>
        `);
        levelsList.append(levelCard);
    });

    updateTime();
    $('#tablet-menu').removeClass('hidden');
}

// Fermer l'UI
function closeUI() {
    $.post(`https://${GetParentResourceName()}/closeUI`, JSON.stringify({}));
    closeAll();
}

function closeAll() {
    $('#lab-menu').addClass('hidden');
    $('#receipt-menu').addClass('hidden');
    $('#tablet-menu').addClass('hidden');
}

// Gestion de la touche ESC
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        e.preventDefault();
        // Notifier le client LUA que ESC a été pressé
        $.post(`https://${GetParentResourceName()}/escape`, JSON.stringify({}));
        closeUI();
    }
});

// Utilitaires
function formatMoney(amount) {
    return new Intl.NumberFormat('fr-FR', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 0
    }).format(amount).replace('$US', '$');
}

function capitalizeFirst(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
}

function formatItemName(item) {
    const names = {
        'levure': 'Levure',
        'eau_source': 'Eau de source',
        'sucre': 'Sucre',
        'raisin': 'Raisin',
        'pomme': 'Pomme',
        'mais': 'Maïs',
        'orge': 'Orge'
    };
    return names[item] || item;
}

function GetParentResourceName() {
    return window.location.hostname === '' ? 'zalco' : window.location.hostname;
}

// Debug en local
if (window.location.hostname === '') {
    console.log('Mode debug activé');

    // Test du laboratoire
    setTimeout(() => {
        // openLab(testAlcoholTypes, testLevels);
    }, 1000);
}
