package com.example.assignment1.connection;

import com.example.assignment1.constants.Keys;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProductsData implements ProductsDatabase{

    @Override
    public ResponseEntity<List<Map<String, String>>> getAllProducts()  {
        List<Map<String, String>> allProducts= new ArrayList<>();
        try{
            Statement statement = establishConnection().createStatement();
            ResultSet rs = statement.executeQuery("SELECT * FROM products");
            while(rs.next())
            {
                Map<String,String> data = new HashMap<>();
                data.put("id", rs.getString("id"));
                data.put("productName", rs.getString("productName"));
                data.put("productDescription", rs.getString("productDescription"));
                data.put("photo", rs.getString("photo"));
                allProducts.add(data);
            }
            return new ResponseEntity<>(allProducts, HttpStatus.OK);
        }
        catch (JSONException e){
            return new ResponseEntity<>(allProducts, HttpStatus.INTERNAL_SERVER_ERROR);
        } catch (SQLException e) {
            return new ResponseEntity<>(allProducts, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public ResponseEntity<List<Map<String, String>>> getProducts(JSONObject store) throws SQLException {
        List<Map<String, String>> allProducts= new ArrayList<>();
        try{
            Statement statement = establishConnection().createStatement();
            ResultSet rs = statement.executeQuery("select products.id,  products.productName,   products.productDescription,  products.photo, services.price\n" +
                    "from products \n" +
                    "inner join  stores,services\n" +
                    "where services.productId=products.id and services.storeId=stores.id  and stores.id='"+ store.getString(Keys.STOREID)+"'");
            while(rs.next())
            {
                Map<String,String> data = new HashMap<>();
                data.put("id", rs.getString("id"));
                data.put("productName", rs.getString("productName"));
                data.put("productDescription", rs.getString("productDescription"));
                data.put("photo", rs.getString("photo"));
                data.put("price", rs.getString("price"));
                allProducts.add(data);
            }
            return new ResponseEntity<>(allProducts, HttpStatus.OK);
        }
        catch (JSONException e){
            return new ResponseEntity<>(allProducts, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
