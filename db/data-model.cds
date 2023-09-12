namespace my.bookshop;

entity Books {
  key ID       : Integer;
      title    : String  @Common.Label: 'Title';
      bookshop : String  @Common.Label: 'BookShop';
      stock    : Integer @Common.Label: 'Stock';
}
