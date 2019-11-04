import ClayButton from '@clayui/button';
import ClayIcon from '@clayui/icon';
import ClayLoadingIndicator from '@clayui/loading-indicator';
import ReactDOM from 'react-dom';
import React from 'react';

import {OPEN_SIDE_PANEL, UPDATE_FROM_COMPONENT, IFRAME_LOADED} from '../../utilities/eventsDefinitions.es';
import {debounce} from '../../utilities/index.es';
import SideMenu from './SideMenu.es';
import { ClayIconSpriteContext } from '@clayui/icon';
import PropTypes from 'prop-types';
export default class SidePanel extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			active: null,
			currentUrl: props.url || null,
			loading: true,
			moving: false,
			size: props.size || 'md',
			topDistance: 0,
			visible: !!props.visible,
		};
		this.handleIframeClickOnSubmit = this.handleIframeClickOnSubmit.bind(this);
		this.handleIframeSubmit = this.handleIframeSubmit.bind(this);
		this.handleContentLoaded = this.handleContentLoaded.bind(this);
		this.close = this.close.bind(this);
		this.open = this.open.bind(this);
		this.handlePanelOpenEvent = this.handlePanelOpenEvent.bind(this);
		this.updateTop = this.updateTop.bind(this);
		this.debouncedUpdateTop = debounce(this.updateTop, 250);
		this.panel = React.createRef();
		this.iframeRef = React.createRef();
	}

	componentDidMount() {
		if (this.props.topAnchor) {
			window.addEventListener('resize', this.debouncedUpdateTop);
			this.updateTop();
		}
		if (Liferay) {
			Liferay.on(OPEN_SIDE_PANEL, this.handlePanelOpenEvent);
		}
	}

	handlePanelOpenEvent(e) {
		if (e.id !== this.props.id) {
			return this.close();
		}

		this.open(e.options.url, e.options.slug);

		if (e.options.onAfterSubmit) {
			this.setState({
				onAfterSubmit: e.options.onAfterSubmit
			});
		}
	}

	componentWillUnmount() {
		if (this.props.topAnchor) {
			window.removeEventListener('resize', this.debouncedUpdateTop);
		}
		if (Liferay) {
			Liferay.detach(OPEN_SIDE_PANEL, this.handlePanelOpenEvent);
		}
	}

	updateTop() {
		const {height, top} = this.props.topAnchor.getBoundingClientRect();

		this.setState({
			topDistance: top + height + 'px'
		});
	}

	load(url) {
		this.setState(
			{
				currentUrl: url,
				loading: true
			},
			() => {
				if (
					this.iframeRef.current &&
					this.iframeRef.current.contentWindow
				) {
					this.iframeRef.current.contentWindow.location = this.state.currentUrl;
				}
			}
		);
	}

	setSize(size) {
		if (!size) {
			new Error('Size parameter is mandatory');
		}
		this.setState({size});
	}

	open(url = this.state.currentUrl, active = null) {
		this.setState({active})
		switch (true) {
			case !this.state.visible:
				return this.toggle(true).then(() => {
					this.load(url);
				});
			case url !== this.state.currentUrl:
				return this.load(url);
			default:
				break;
		}
	}

	close() {
		this.toggle(false).then(() => {
			this.setState({
				active: null,
				currentUrl: null,
				loading: true,
			});
		});
	}

	toggle(status = !this.state.visible) {
		return new Promise(resolve => {
			this.setState({moving: true, visible: status});
			this.panel.current.addEventListener(
				'transitionend',
				() => {
					this.setState({moving: false}, () => resolve(status));
				},
				{
					once: true
				}
			);
		});
	}

	handleIframeSubmit(e) {
		if(e.id !== this.props.id) {
			return;
		}
		Liferay.detach(IFRAME_LOADED, this.handleIframeSubmit);
		Liferay.fire(UPDATE_FROM_COMPONENT, {id: this.props.id});

		if (this.props.onSubmit) {
			this.props.onSubmit();
		}

	}

	handleIframeClickOnSubmit() {
		Liferay.on(IFRAME_LOADED, this.handleIframeSubmit);

		setTimeout(() => {
			Liferay.detach(IFRAME_LOADED, this.handleIframeSubmit);
		}, 3000)
	}

	handleContentLoaded() {
		Liferay.fire(IFRAME_LOADED, {
			id: this.props.id
		})

		this.setState({
			loading: false
		});

		try {
			const iframeBody = this.iframeRef.current.contentDocument.querySelector(
				'body'
			);
	
			iframeBody.classList.add('within-commerce-iframe');
	
			const submitButton = iframeBody.querySelector('[type="submit"]');

			if (submitButton) {
				console.log('added listener')
				submitButton.addEventListener('click', this.handleIframeClickOnSubmit);
			}
		} catch (error) {
			throw new Error(`Cannot access to iframe body. Url: "${this.state.currentUrl}"`)
		}
	}

	render() {
		const visibility = this.state.visible ? 'is-visible' : 'is-hidden';
		const loading =
			this.state.loading || (this.state.moving && this.state.visible)
				? 'is-loading'
				: '';

		const content = (
			<div
				className={`side-panel side-panel-${this.state.size} ${visibility} ${loading}`}
				ref={this.panel}
				style={{top: this.state.topDistance}}
			>
				<SideMenu
					active={this.state.active}
					items={this.props.items}
					open={this.open}
				/>

				<ClayButton
					className="btn-close"
					displayType="monospaced"
					onClick={() => this.close()}
				>
					<ClayIcon spritemap={this.props.spritemap} symbol="times" />
				</ClayButton>

				<div className="tab-content">
					<div className="loader">
						<ClayLoadingIndicator />
					</div>
					<div className="active fade show tab-pane" role="tabpanel">
						{!(this.state.moving && this.state.visible) && (
							<iframe
								frameBorder="0"
								onLoad={this.handleContentLoaded}
								ref={this.iframeRef}
								src={this.state.currentUrl}
							></iframe>
						)}
					</div>
				</div>
			</div>
		)

		return ReactDOM.createPortal(
			this.props.spritemap 
			? (
				<ClayIconSpriteContext.Provider value={this.props.spritemap}>
					{content}
				</ClayIconSpriteContext.Provider>
			)
			: content,
			this.props.portalWrapperId
				? document.getElementById(this.props.portalWrapperId)
				: document.querySelector('body')
		);
	}
}

SidePanel.propTypes = {
	id: PropTypes.string,
	items: PropTypes.any,
	size: PropTypes.string,
	spritemap: PropTypes.string,
	topAnchor: PropTypes.any
}