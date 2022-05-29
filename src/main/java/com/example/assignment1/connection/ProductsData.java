package com.example.assignment1.connection;

import com.example.assignment1.constants.Keys;
import com.example.assignment1.constants.Messages;
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
    public ResponseEntity<List<Map<String, String>>> getProducts(JSONObject store) throws SQLException {
        List<Map<String, String>> allProducts= new ArrayList<>();
        try{
            Statement statement = establishConnection().createStatement();
            ResultSet rs = statement.executeQuery("SELECT p.productName, p.productDescription, p.photo, s.price\n" +
                    "FROM products p , services s \n" +
                    "INNER JOIN services\n" +
                    "INNER JOIN stores\n" +
                    "ON services.storeId = stores.id \n" +
                    "Where s.storeId = '" + store.getString(Keys.STOREID) + "'");
            while(rs.next())
            {
                Map<String,String> data = new HashMap<>();
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
