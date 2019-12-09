import React from 'react';

import {launcher} from '../../utilities/index.es';
import modalLauncher from './entry.es';
import { OPEN } from '../../utilities/eventsDefinitions.es';

import '../../styles/main.scss'

const props = {
	actions: [
		{
			definition: 'save'
		}
	],
	closeOnSubmit: true,
	id: 'test-modal',
	showCancel: true,
	size: 'full-screen',
	spritemap: './assets/icons.svg',
	submitLabel: 'Create',
	title: 'Title',
	url: 'http://localhost:9000/modal-content.html'
};

modalLauncher('modal', 'modal-root-id', props);

launcher(
	() => (
		<button
			className="btn btn-primary"
			onClick={() => Liferay.fire(OPEN, {id: "test-modal"})}
		>
			Open modal
		</button>
	),
	'modal-trigger-root-id',
	'modal-trigger-root-id',
	props
);
