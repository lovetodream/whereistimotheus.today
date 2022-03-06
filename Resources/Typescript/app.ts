// eslint-disable-next-line @typescript-eslint/no-explicit-any
declare const mapkit: any;

mapkit.init({
    authorizationCallback: (done: (arg0: string) => void) => {
        fetch("/token")
            .then(res => res.text())
            .then(token => done(token))
            .catch(error => {
                console.log(error);
            });
    }
});

fetch("/data")
    .then(res => res.json())
    .then(data => {
        console.log(data);

        const center = new mapkit.Coordinate(data.location.latitude, data.location.longitude),
            span = new mapkit.CoordinateSpan(0.25, 0.25),
            region = new mapkit.CoordinateRegion(center, span),
            map = new mapkit.Map("map", {
                showsCompass: mapkit.FeatureVisibility.Hidden,
                showsZoomControl: false,
                showsMapTypeControl: false,
            });

        setTimeout(() => {
            map.setRegionAnimated(region, true);
        }, 1000);

    });
  
