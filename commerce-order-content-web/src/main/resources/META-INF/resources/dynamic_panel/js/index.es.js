import React from 'react';
import ReactDOM from 'react-dom';

import DynamicPanel from './DynamicPanel.es';

const props = {
    elements : [
        {
          icon: 'list-view',
          url: 'http://localhost:4000/api/text/list',
          pageName: 'Comments'
        },
        {
          icon: 'print',
          url: 'http://localhost:4000/api/text/print',
          pageName: 'Edit'
        },
        {
          icon: 'search',
          url: 'http://localhost:4000/api/text/search',
          pageName: 'Changelog'
        }
    ],
    spritemap : 'commerce-icons.svg'
}

export default function(id) {
  console.log(id);
	const portletFrame = window.document.getElementById(id);

	ReactDOM.render(<DynamicPanel {...props} />, portletFrame);
}