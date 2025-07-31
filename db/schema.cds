namespace cap-ui5-standalone;

using {
    cuid,
    managed
} from '@sap/cds/common';


entity Products : cuid, managed {
    NAME  : String(100);
    PRICE : Decimal;

}
