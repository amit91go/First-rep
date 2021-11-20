package de.uniba.dsg.jaxrs;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import de.uniba.dsg.jaxrs.resources.SearchArtistResource;
import de.uniba.dsg.jaxrs.resources.SearchTrackResource;
import de.uniba.dsg.jaxrs.resources.LocalIPResponseFilter;

@ApplicationPath("/")
/**
 * TODO:
 * The API should always consume JSON
 * The API should always respond with JSON
 */
public class MusicApi extends Application {
    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> resources = new HashSet<>();
        resources.add(SearchArtistResource.class);
        resources.add(SearchTrackResource.class);
        resources.add(LocalIPResponseFilter.class);
        return resources;
    }
}
