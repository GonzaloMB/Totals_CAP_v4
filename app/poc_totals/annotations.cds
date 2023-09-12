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
