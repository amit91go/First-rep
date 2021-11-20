package de.uniba.dsg.jaxrs.resources;

import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.container.ContainerResponseContext;
import javax.ws.rs.container.ContainerResponseFilter;
import javax.ws.rs.core.Response;
import javax.ws.rs.ext.Provider;
import java.net.*;
import java.util.logging.Logger;

public class LocalIPResponseFilter implements ContainerResponseFilter {


    @Override
    public void filter(ContainerRequestContext requestContext, ContainerResponseContext responseContext)
        throws IOException {
        String hostIP = new String();
        try{
        Enumeration e = NetworkInterface.getNetworkInterfaces();
        while(e.hasMoreElements())
        {
            NetworkInterface n = (NetworkInterface) e.nextElement();
            Enumeration ee = n.getInetAddresses();
            while (ee.hasMoreElements())
            {
                InetAddress i = (InetAddress) ee.nextElement();
                if((i instanceof Inet4Address) && !(i.isLoopbackAddress())){
                        System.out.println(i.getHostAddress());
                        hostIP = i.getHostAddress();
                        System.out.println("IP: "+ hostIP);
                }
            }
        }
        }catch(Exception e1){System.out.println(e1.toString());}

            responseContext.getHeaders().add("srcIP", hostIP);
            System.out.println(responseContext.getHeaders());
    }
}
