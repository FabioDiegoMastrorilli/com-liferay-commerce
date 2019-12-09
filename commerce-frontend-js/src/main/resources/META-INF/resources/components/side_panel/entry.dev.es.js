import launcher from './entry.es';

import '../../styles/main.scss';

window.SidePanel = launcher('sidePanel', 'side-panel-root-id', {
	id: 'sidePanelTestId',
	size: 'md',
	spritemap: './assets/icons.svg',
	topAnchorSelector: '.top-anchor'
});
