using {cap.ui5.standalone as cap} from '../db/schema.cds';

service ProductService {
    entity Products as projection on cap.Products;
}
