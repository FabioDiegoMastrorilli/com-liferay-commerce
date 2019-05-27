create table CPLCommerceGroupAccountRel (
	uuid_ VARCHAR(75) null,
	CPLCommerceAccountGroupRelId LONG not null primary key,
	companyId LONG,
	userId LONG,
	userName VARCHAR(75) null,
	createDate DATE null,
	modifiedDate DATE null,
	commercePriceListId LONG,
	commerceAccountGroupId LONG,
	order_ INTEGER,
	lastPublishDate DATE null
);

create table CPLAccountGroupEntryRel (
	uuid_ VARCHAR(75) null,
	CPLAccountGroupEntryRelId LONG not null primary key,
	groupId LONG,
	companyId LONG,
	userId LONG,
	userName VARCHAR(75) null,
	createDate DATE null,
	modifiedDate DATE null,
	commercePriceListId LONG,
	commerceAccountGroupId LONG,
	order_ INTEGER,
	lastPublishDate DATE null
);

create table CommercePriceEntry (
	uuid_ VARCHAR(75) null,
	externalReferenceCode VARCHAR(75) null,
	commercePriceEntryId LONG not null primary key,
	companyId LONG,
	userId LONG,
	userName VARCHAR(75) null,
	createDate DATE null,
	modifiedDate DATE null,
	commercePriceListId LONG,
	CPInstanceUuid VARCHAR(75) null,
	CProductId LONG,
	price DECIMAL(30, 16) null,
	promoPrice DECIMAL(30, 16) null,
	hasTierPrice BOOLEAN,
	lastPublishDate DATE null
);

create table CommercePriceList (
	uuid_ VARCHAR(75) null,
	externalReferenceCode VARCHAR(75) null,
	commercePriceListId LONG not null primary key,
	groupId LONG,
	companyId LONG,
	userId LONG,
	userName VARCHAR(75) null,
	createDate DATE null,
	modifiedDate DATE null,
	commerceCurrencyId LONG,
	parentCommercePriceListId LONG,
	name VARCHAR(75) null,
	priority DOUBLE,
	displayDate DATE null,
	expirationDate DATE null,
	lastPublishDate DATE null,
	status INTEGER,
	statusByUserId LONG,
	statusByUserName VARCHAR(75) null,
	statusDate DATE null
);

create table CommercePriceListAccountRel (
	uuid_ VARCHAR(75) null,
	commercePriceListAccountRelId LONG not null primary key,
	companyId LONG,
	userId LONG,
	userName VARCHAR(75) null,
	createDate DATE null,
	modifiedDate DATE null,
	commerceAccountId LONG,
	commercePriceListId LONG,
	order_ INTEGER,
	lastPublishDate DATE null
);

create table CommerceTierPriceEntry (
	uuid_ VARCHAR(75) null,
	externalReferenceCode VARCHAR(75) null,
	commerceTierPriceEntryId LONG not null primary key,
	companyId LONG,
	userId LONG,
	userName VARCHAR(75) null,
	createDate DATE null,
	modifiedDate DATE null,
	commercePriceEntryId LONG,
	price DECIMAL(30, 16) null,
	promoPrice DECIMAL(30, 16) null,
	minQuantity INTEGER,
	lastPublishDate DATE null
);