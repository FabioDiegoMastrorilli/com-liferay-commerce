import template from './OrderSummary.soy';
import Component from 'metal-component';
import Soy, {Config} from 'metal-soy';
import dom from 'metal-dom';

import 'clay-modal';
import '../commerce_table/CommerceTable.es';
import './ItemOverview.es';

const fakeSummaryData = [
	{
		title: "units",
		value: "16 of 4 items",
	},
	{
		title: "subtotal",
		value: "$ 32,000.000",
	},
	{
		title: "discount",
		value: "0% Off",
	},
	{
		title: "grandtotal",
		value: "$ 32,000.000",
		size: "big"
	}
];

const fakeItemData = {
	id: 'ORDER123',
	thumbnail: '//via.placeholder.com/70',
	sku: 'SKU0123',
	name: 'Test Product',
	note: 'Please try not to deliver this product on the 30th february',
	description: 'Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem. Curabitur arcu erat, accumsan id imperdiet et, porttitor at sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus suscipit tortor eget felis porttitor volutpat. Praesent sapien massa, convallis a pellentesque nec, egestas non nisi. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. Nulla porttitor accumsan tincidunt. Nulla quis lorem ut libero malesuada feugiat. Curabitur aliquet quam id dui posuere blandit. Nulla porttitor accumsan tincidunt. Mauris blandit aliquet elit, eget tincidunt nibh pulvinar a. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
	tierPricing: [
		{
			quantity: 5,
			price: '$ 200.00'
		},
		{
			quantity: 15,
			price: '$ 180.00'
		},
		{
			quantity: 30,
			price: '$ 150.00'
		},
		{
			quantity: 50,
			price: '$ 120.00'
		},
		{
			quantity: 100,
			price: '$ 100.00'
		}
	],
	deliveryDate: '2019-03-07',
	price: '200.00',
	discount: '10 %',
	giftQuantity: 4,
	quantity: 10,
	priceCurrency: '$'
};

class OrderSummary extends Component {

	attached(){
		this.summaryData = fakeSummaryData;
		this.itemData = fakeItemData;
	}

	_handleCloseModal(e) {
		e.preventDefault();
	}

	_handleItemClick(itemId){
		if (this.itemData && this.itemData.id !== itemId && this.itemDataModified){
			this._showModal = true;
		} else {
			this._getItemData();
		}
	}

	_handleModalCancelClick(){
		dom.exitDocument(this.refs.modal._overlayElement);
		this._showModal = false;
	}
	
	_handleModalDiscardClick() {
		console.log('discard');
		dom.exitDocument(this.refs.modal._overlayElement);
		this._showModal = false;
		this._getItemData();
	}

	_getItemData(itemId){
		if(!this.tableItemsAPI){
			throw new Error('Items API endpoint not defined');
		}
		return fetch(
			this.tableItemsAPI + '/' + itemId
		).then(
			response => response.json()
		).then(this._updateItemData);
	}

	_updateItemData(itemData){
		this.itemData = itemData;
	}

	_handleItemModifications(itemDataModified){
		this.itemDataModified = itemDataModified;
	}
	
	_handleSubmitItemChanges(itemData){
		this._saveItemChanges(itemData)
	}

	_saveItemChanges(itemData){
		if(!this.tableItemsAPI){
			throw new Error('Items API endpoint not defined');
		}
		return fetch(
			this.tableItemsAPI + '/' + itemData.id,
			{
				body: JSON.stringify(itemData),
				headers: new Headers({'Content-Type': 'application/json'}),
				method: 'PUT'
			}
		).then(
			response => response.json()
		).then(
			this._updateItemData
		).catch(e => {
			console.log(e)
		})
	}
}

OrderSummary.STATE = {
	adminPrivileges: Config.bool().value(false),
	currentPage: Config.number().required(),
	dataProviderKey: Config.string().required(),
	dataSetAPI: Config.string().required(),
	disableAJAX: Config.bool(),
	id: Config.string(),
	items: Config.array(
		Config.shapeOf(
			{
				thumbnail: Config.string(),
				orderId: Config.oneOfType(
					[
						Config.string(),
						Config.number()
					]
				).required(),
				orderItemId: Config.oneOfType(
					[
						Config.string(),
						Config.number()
					]
				).required(),
				price: Config.string().required(),
				name: Config.string().required(),
				discount:  Config.string(),
				sku: Config.string().required(),
				viewShipmentsURL: Config.string()
			}
		)
	).required(),
	pageSize: Config.number().required(),
	paginationBaseHref: Config.string(),
	paginationEntries: Config.array().required(),
	paginationSelectedEntry: Config.number().required(),
	schema: Config.object().required(),
	selectable: Config.bool(),
	spritemap: Config.string().required(),
	commerceSpritemap: Config.string().required(),
	tableName: Config.string().required(),
	totalItems: Config.number().required(),
	showItemOverview: Config.bool(),
	showTableSummary: Config.bool(),
	summaryData: Config.array(),
	_itemOverviewStage: Config.string().oneOf(
		[
			'empty',
			'overview',
			'edit'
		]
	),
	itemData: Config.shapeOf(
		{
			id: Config.oneOfType(
				[
					Config.number(),
					Config.string()
				]
			),
			thumbnail: Config.string(),
			sku: Config.string().required(),
			name: Config.string().required(),
			note: Config.string().required(),
			description: Config.string(),
			deliveryDate: Config.string(),
			tierPricing: Config.array(),
			price: Config.string(),
			discount: Config.string(),
			giftQuantity: Config.number(),
			quantity: Config.number()
		}
	),
	itemDataModified: Config.bool().value(false),
	tableItemsAPI: Config.string(),
	_showModal: Config.bool().value(false)
};

Soy.register(OrderSummary, template);

export {OrderSummary};
export default OrderSummary;