using {cap-ui5-standalone} from '../db/schema.cds';

service ProductService {
    entity Products as projection on cap-ui5-standalone.Products;
}
