import 'package:custos/models/tip.dart';

class TipBrain {
  List<Tip> _tipBank = [
    Tip('Always be aware',
        'While going through your day to day duties of work, kids, school run, dinner – all those fun life admin tasks that never stop, keep awareness top of mind. Regularly check on your home security and look for anything that’s out of place, don’t forget to arm your alarm when leaving in a rush, and always take note of your surroundings.'),
    Tip('Never pull over',
        'When someone points at your car, claiming that something is wrong. Suspects use this tactic to get you to open your window or get out of the car. Rather drive to the nearest garage or shop where you will be safe to have a look yourself or can ask for assistance.'),
    Tip('Always remember to lock your doors',
        'When driving. Suspects often hijack or smash-and-grab motorists stopped at a red traffic light. Don’t make it any easier for them by simply leaving your doors unlocked.'),
    Tip('Limit distractions in parking lots',
        'Tuck your phone safely in your purse so you can keep your head up to look around and pay attention to your surroundings. If it’s late and you feel uneasy or parked far from the entrance, ask a security guard to escort you to your car. If you reach your car and notice that it has a flat tire, back away immediately and return to the shop from where you can safely ask for assistance or call for help.'),
    Tip('Never walk alone',
        'If it can’t be helped especially at night, take all possible precautions to ensure your safety. Keep your phone out of sight and refrain from listening to music, as you won’t be able to hear someone approaching you from behind.'),
    Tip('Make eye contact',
        'By doing this to other pedestrians, you send them a strong defensive signal that you see them and could identify them if necessary. Look them in the eye and give a polite nod to acknowledge them.'),
    Tip('Scream at the top of your lungs',
        'Scream and twist your arm up and down if someone tries to grab you. Do anything you can to draw as much attention to yourself as possible.'),
    Tip('Hit the body parts that are the most tender',
        'If you have to defend yourself against an attacker. You want to aim at whatever is going to hurt the most, regardless of the attacker’s strength and size. These are vulnerable areas like the eyes, nose, throat, groin and shin.'),
    Tip('Never trust a stranger',
        'Based on his appearance. Most offenders don’t even look like criminals but your friendly next door neighbour, and are sometimes dressed quite well.'),
    Tip('Be mindful of the way you dress',
        'If you will be walking alone. Shoes like wedges and high heels, and tight skirts, will be hard to run in while scarves and long necklaces are easy to grab. Play a scenario through your mind and try to determine if you would be able to easily defend yourself with what you’re wearing.'),
    Tip('Never leave your handbag unattended',
        'Purse snatchers are very sly and will grab your bag and disappear the moment you turn your back. Being a woman you are most probably prepared for any situation and likely carry some form of documentation containing your physical address. That information in the wrong hands could put you at further risk.'),
  ];

  DateTime day = DateTime.now();
  int index;

  String getTipTitle() {
    switch(day.weekday) {
      case 1:
        index = 0;
        break;
      case 2:
        index = 1;
        break;
      case 3:
        index = 2;
        break;
      case 4:
        index = 3;
        break;
      case 5:
        index = 4;
        break;
      case 6:
        index = 5;
        break;
      case 7:
        index = 6;
        break;
    }

    return _tipBank[index].tipTitle;
  }

  String getTipDescription() {
    switch(day.weekday) {
      case 1:
        index = 0;
        break;
      case 2:
        index = 1;
        break;
      case 3:
        index = 2;
        break;
      case 4:
        index = 3;
        break;
      case 5:
        index = 4;
        break;
      case 6:
        index = 5;
        break;
      case 7:
        index = 6;
        break;
    }

    return _tipBank[index].tipDescription;
  }
}
