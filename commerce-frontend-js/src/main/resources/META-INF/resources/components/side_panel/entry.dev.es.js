import launcher from './entry.es';

import '../../styles/main.scss';

window.SidePanel = launcher('sidePanel', 'side-panel', {
	id: 'sidePanelTestId',
	size: 'md',
	spritemap: './assets/icons.svg',
	topAnchor: document.querySelector('.top-anchor'),
	items: [
		{
			slug: 'comments',
			href: 'http://google.com',
			icon: 'comments'
		},
		{
			slug: 'edit',
			href: 'http://google.com',
			icon: 'pencil'
		},
		{
			slug: 'changelog',
			href: 'http://google.com',
			icon: 'restore'
		},
	]
});
