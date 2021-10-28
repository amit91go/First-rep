package de.uniba.dsg.jaxrs.resources;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import com.neovisionaries.i18n.CountryCode;
import com.wrapper.spotify.exceptions.SpotifyWebApiException;
import com.wrapper.spotify.exceptions.detailed.BadRequestException;
import com.wrapper.spotify.model_objects.specification.ArtistSimplified;
import com.wrapper.spotify.model_objects.specification.Track;
import com.wrapper.spotify.requests.data.artists.GetArtistsTopTracksRequest;
import de.uniba.dsg.CustomSpotifyApi;
import de.uniba.dsg.interfaces.ChartApi;
import de.uniba.dsg.jaxrs.exceptions.ClientRequestException;
import de.uniba.dsg.jaxrs.exceptions.RemoteApiException;
import de.uniba.dsg.jaxrs.exceptions.ResourceNotFoundException;
import de.uniba.dsg.models.ErrorMessage;
import de.uniba.dsg.models.Song;

@Path("api/charts")
public class ChartResource implements ChartApi {
	@Override
	@GET
	@Path("{artistid}")
	public List<Song> getTopTracks(@PathParam("artistid") String artistId) {
		System.out.println("Service requested");
		// TODO Auto-generated method stub
		if (artistId == null) {
			throw new ClientRequestException(new ErrorMessage("Required path parameter is missing: artist-Id"));
		}

		try {
			GetArtistsTopTracksRequest trackRequest = CustomSpotifyApi.getInstance().getArtistsTopTracks(artistId, CountryCode.getByCode("DE")).build();		
			// get search results
			Track[] tracks = trackRequest.execute();		
			// no artist found
			if (tracks != null && tracks.length == 0) {
				throw new ResourceNotFoundException(new ErrorMessage(String.format("No tracks found for artistId: %s", artistId)));
			}

			List<Song> topTracks = new ArrayList<Song>();
			for(int i=0; i< 5; i++)
			{
				Song song = new Song();
				song.setId(tracks[i].getId());
				song.setTitle(tracks[i].getName());
				StringBuffer artists = new StringBuffer();
				for(ArtistSimplified artist: tracks[i].getArtists())
				{
					if(artists.length() != 0)
						artists.append(", ");
					artists.append(artist.getName());

				}
				song.setArtists(artists.toString());
				topTracks.add(song);
				if(i+1 == tracks.length)
					break;
			}

			return topTracks;
		}catch (BadRequestException ex) {
			throw new ResourceNotFoundException(new ErrorMessage("Invalid Artist-Id"));	
		}catch (SpotifyWebApiException | IOException e) {
			throw new RemoteApiException(new ErrorMessage(e.getMessage()));
		}
	}

}
