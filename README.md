<h1 align="center"> SAP CAP (Node.js) | Totals in Fiori Elements v4 Analytical Table </h1>
<div align="center">
Project made it with SAP CAP Node.js version and Fiori Elements v4
</div>
<div align="center">
  <h3> 📝 
    <a href="https://www.linkedin.com/in/gonzalo-meana-balseiro-90a523188/">
      Contact Me
    </a>
  </h3>
    <h3> 💻  
    <a href="http://gonzalomb.com">
      Check my website
    </a>
  </h3>
</div>

## Starting 🚀
Project created using SAP CAP technology, Hana database for the back-end and an annotations to define totals in Fiori Elements.

### Pre-requirements 📋
The project contains these folders and files :

File or Folder | Purpose
---------|----------
`db/` | your domain models and data go here
`srv/` | your service models and code go here
`app/` | content for UI frontends goes here
`package.json` | project metadata and configuration

_Tools you need to be able to develop this application_
* **SAP BAS** 

## Practical case ⚙️

_In this application we are going to develop both the back-end and the front-end part_

### Back-end 🔩
#### 1. DB/
This folder contains the scripts for creating the application's database. This is where data models are defined and relationships between tables are specified.

```abap
namespace my.bookshop;

entity Books {
  key ID       : Integer;
      title    : String  @Common.Label: 'Title';
      bookshop : String  @Common.Label: 'BookShop';
      stock    : Integer @Common.Label: 'Stock';
}
```
This code defines an entity called "Books" in the namespace "my.bookshop".

#### 2. SRV/
This is the folder that contains the backend service of the application. This is where the application's business logic, data models, and APIs are defined.

```abap
using my.bookshop as my from '../db/data-model';

service CatalogService {
    entity Books as projection on my.Books;
}
```
This code defines a service called "CatalogService". It imports the "my.bookshop" namespace using the "my" alias and imports the data model from the "../db/data-model" file.

The service then defines an entity called "Books" using a projection on the "my.Books" entity. This means that the "Books" entity inherits all the properties and annotations of the "my.Books" entity.

The service can then expose APIs that allow clients to perform CRUD (Create, Read, Update, Delete) operations on the "Books" entity.

### Front-End ⌨️
#### 2. APP/
This folder contains the front-end web application. This is where the user interface of the application is defined.

The following implementation is done for V4-type applications that use List Reports in SAP CAP. The first thing we will do is modify the table type and check our UI5 version. To do this, we will change the following parameters in our 'manifest.json'.


1. Manifest.json:

Change table type for AnalyticalTable

```json
...
    "targets": {
        "BooksList": {
          "type": "Component",
          "id": "BooksList",
          "name": "sap.fe.templates.ListReport",
          "options": {
            "settings": {
              "initialLoad": "Enabled",
              "entitySet": "Books",
              "controlConfiguration": {
                "@com.sap.vocabularies.UI.v1.LineItem": {
                  "tableSettings": {
                    "type": "AnalyticalTable"
                  }
                }
              },
...
```
Change version:
```json
...
"sap.platform.cf": {
        "ui5VersionNumber": "1.112.1"
    },
    "sap.ui5": {
        "flexEnabled": true,
        "dependencies": {
            "minUI5Version": "1.112.1",
            "libs": {
                "sap.m": {},
                "sap.ui.core": {},
                "sap.ushell": {},
                "sap.fe.templates": {}
            }
        },
...
```

2. Annotations.cds 
After making these modifications, we will add the corresponding annotations in the 'annotations.cds' file of our app. hese annotations can be divided into three blocks. The UI.PresentationVariant annotation will be responsible for displaying the default totals in the table footer for the fields we define.

```abap
...
UI.PresentationVariant            : {
        Total         : [stock],
        Visualizations: ['@UI.LineItem']
    },
...
```
We will add the Aggregation.ApplySupported annotation to specify the fields by which grouping is supported to display totals by groupings.

```abap
...
    Aggregation.ApplySupported        : {GroupableProperties: [
        title,
        bookshop
    ]},
    ...
```
We create the custom action, which will be the button that opens the popup to download or upload the CSV to our table.

```abap
 ...
 	    Aggregation.CustomAggregate #stock: 'Edm.Int32',
...
```
And finally, outside the scope of annotate service.Operating_Cost_Extract_Report with @( ), we will define, just as we did with hidden fields, the Measure-type fields and the type of operation they will perform, in this case, summations.

```abap
..
    stock  @Analytics.Measure  @Aggregation.default: #SUM;
...
```
Our code should look like this:

```abap
using CatalogService as service from '../../srv/cat-service';

annotate service.Books with @(
    Aggregation.ApplySupported        : {GroupableProperties: [
        title,
        bookshop
    ]},
    Aggregation.CustomAggregate #stock: 'Edm.Int32',
    UI.PresentationVariant            : {
        Total         : [stock],
        Visualizations: ['@UI.LineItem']
    },
    UI.SelectionFields                : [
        title,
        bookshop,
        stock,
    ],
    UI.HeaderInfo                     : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Book Stock Totals',
        TypeNamePlural: 'Book Stock Totals',
        Title         : {Value: 'Book Stock Totals'},
    },
    UI.LineItem                       : [
        {
            $Type: 'UI.DataField',
            Value: title,
        },
        {
            $Type: 'UI.DataField',
            Value: bookshop,
        },
        {
            $Type: 'UI.DataField',
            Value: stock,
        },
    ]
);

annotate service.Books with @(
    UI.FieldGroup #GeneratedGroup1: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: title,
            },
            {
                $Type: 'UI.DataField',
                Value: bookshop,
            },
            {
                $Type: 'UI.DataField',
                Value: stock,
            },
        ],
    },
    UI.Facets                     : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'GeneratedFacet1',
        Label : 'General Information',
        Target: '@UI.FieldGroup#GeneratedGroup1',
    }, ]
) {

    stock  @Analytics.Measure  @Aggregation.default: #SUM;
    ID     @UI.Hidden: true;
};
```
3. Package.json
Finally, our CAP project is using the Node.js version instead of the Java version. This causes issues when grouping, and the application makes a call like:
```php
GET BooksAggregate?$apply=concat(groupby((ID,category,title))/aggregate($count%20as%20UI5__leaves),groupby((category))/concat(aggregate($count%20as%20UI5__count), top(72))) HTTP/1.1.
```
This will fail because 'concat' is not available in the Node.js version.
https://www.notion.so/Fiori-Elements-v4-Analytical-Table-with-CAP-Node-js-294b17e36e7147a2ae0bcbefc65489b6?pvs=4#8f611bd58a5e4874bcef2c2fa039d0cb
To resolve this issue, there is an experimental feature that you can enable by adding the following code to the package.json file of your CAP project:

```json
    "cds": {
        "requires": {
            "db": "hana"
        },
        "features": {
            "odata_new_parser": true
          }
    },
```

## Acknowledgement 📚
- **CAP CDS**
- **cap annotations**
- **Fiori Elements**

## Built with 🛠️
_Back-end:_
* **CAP CDS**

_Gateway:_
* **oData**

_Front-End:_
* **cap annotations**
* **Fiori Elements**

## Next Steps

- Open a new terminal and run `cds watch` 
- (in VS Code simply choose _**Terminal** > Run Task > cds watch_)
- Start adding content, for example, a [db/schema.cds](db/schema.cds).

## Learn More

Learn more at https://cap.cloud.sap/docs/get-started/.

---

⌨️ with ❤️ love [GonzaloMB](https://github.com/GonzaloMB) 😊
