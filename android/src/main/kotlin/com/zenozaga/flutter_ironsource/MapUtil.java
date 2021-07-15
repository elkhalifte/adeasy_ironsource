package com.zenozaga.flutter_ironsource;
import java.util.HashMap;

public class MapUtil {

    private  HashMap<String, Object> object;

    MapUtil(){
        object = new HashMap<String, Object>();
    };


    public MapUtil put(String key, Object data){

        object.put(key,data);
        return this;

    }


    public HashMap map (){
        return object;
    }


    public static  MapUtil getInstance(){
        return new MapUtil();
    }

    public static  boolean isMap(Object item){
        return item instanceof HashMap;
    }

    public static Object getIn(Object item, String key){

        if(item instanceof HashMap){
            return ((HashMap<?, ?>) item).get(key);
        }else{
            return null;
        }

    }

}
