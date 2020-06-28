class WalkthroughSlider {

  String imagePath;
  String title;
  String description;

  void setImagePath(String img) {
    imagePath = img;
  }

  void setTitle(String tit) {
    title = tit;
  }

  void setDescription(String desc) {
    description = desc;
  }

  String getImagePath() {
    return imagePath;
  }

  String getTitle() {
    return title;
  }

  String getDescription() {
    return description;
  }
}

List<WalkthroughSlider> getSlides() {
  List<WalkthroughSlider> slides = List<WalkthroughSlider>();

  WalkthroughSlider walkthroughSlider = WalkthroughSlider();

  // First slide
  walkthroughSlider.setImagePath('assets/Walkthrough1.jpg');
  walkthroughSlider.setTitle('SOS Button');
  walkthroughSlider.setDescription('Click on the SOS button to send SMS to your contacts and directly call your primary contact, and if you didn\'t save a primary contact then it will call the police. And you can keep sending SMS containing your updated location');
  slides.add(walkthroughSlider);

  walkthroughSlider = WalkthroughSlider();

  // Second slide
  walkthroughSlider.setImagePath('assets/Walkthrough2.jpg');
  walkthroughSlider.setTitle('Safe Button');
  walkthroughSlider.setDescription('Click on the Safe button to send SMS to your contacts telling them your are ok');
  slides.add(walkthroughSlider);

  walkthroughSlider = WalkthroughSlider();

  // Third slide
  walkthroughSlider.setImagePath('assets/Walkthrough3.jpg');
  walkthroughSlider.setTitle('Danger Zones');
  walkthroughSlider.setDescription('You can find red circles in the map which means that the SOS button was used by other user in that zone');
  slides.add(walkthroughSlider);

  walkthroughSlider = WalkthroughSlider();

  // Fourth slide
  walkthroughSlider.setImagePath('assets/Walkthrough4.jpg');
  walkthroughSlider.setTitle('Tips');
  walkthroughSlider.setDescription('Helpful tips that change every 24 hours and can be saved');
  slides.add(walkthroughSlider);

  return slides;
}