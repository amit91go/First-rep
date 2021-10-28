package de.uniba.dsg.jaxrs.resources;

import java.io.IOException;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.QueryParam;

import com.wrapper.spotify.exceptions.SpotifyWebApiException;
import com.wrapper.spotify.exceptions.detailed.BadRequestException;
import com.wrapper.spotify.model_objects.specification.Track;
import com.wrapper.spotify.requests.data.tracks.GetTrackRequest;

import de.uniba.dsg.CustomSpotifyApi;
import de.uniba.dsg.interfaces.ImageApi;
import de.uniba.dsg.jaxrs.exceptions.ClientRequestException;
import de.uniba.dsg.jaxrs.exceptions.RemoteApiException;
import de.uniba.dsg.jaxrs.exceptions.ResourceNotFoundException;
import de.uniba.dsg.models.ErrorMessage;

@Path("api/covers")
public class ImageResource implements ImageApi {

	@Override
	@GET
	@Path("{trackid}")
	public String getCoverImage(@PathParam("trackid") String trackId)
	{
		System.out.println("Service requested");
		if (trackId == null) {
			throw new ClientRequestException(new ErrorMessage("Required query parameter is missing: trackId"));
		}

		try {		
			GetTrackRequest trackRquest = CustomSpotifyApi.getInstance().getTrack(trackId).build();
			Track track = trackRquest.execute();
			if (track == null) {
				throw new ResourceNotFoundException(new ErrorMessage(String.format("No tracks found for trackId: %s", trackId)));
			}
			
			return track.getAlbum().getHref();
			
		}catch (BadRequestException e){
			throw new ResourceNotFoundException(new ErrorMessage("Invalid country code!"));
		}catch (SpotifyWebApiException | IOException e) {
			throw new RemoteApiException(new ErrorMessage(e.getMessage()));
		}
	}

}
