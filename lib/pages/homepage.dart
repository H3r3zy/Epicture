import 'package:epicture_flutter/auth/Auth.dart';
import 'package:epicture_flutter/pages/Me.dart';
import 'package:epicture_flutter/pages/PostPage.dart';
import 'package:epicture_flutter/pages/home.dart';
import 'package:epicture_flutter/pages/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:epicture_flutter/globals.dart' as globals;

class HomePageState extends State<HomePage> {
	int _currentIndex = 0;
	var _boxIsScrolled = false;
	final List<Widget> _children = [
		new Home(),
		new SearchPage(),
		new Me()
	];
	ScrollController _scroll;

	void onTabTapped(int index) {
		setState(() {
			this._currentIndex = index;
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: NestedScrollView(
				controller: _scroll,
				headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
					return <Widget>[
						SliverOverlapAbsorber(
							handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
							child: SliverAppBar(
								title: Text("{Epicture.}"),
								backgroundColor: Color.fromRGBO(16, 16, 16, 1.0),
								pinned: false,
								floating: false,
								forceElevated: boxIsScrolled,
								actions: (globals.accessToken != null) ? [
									IconButton(
										icon: Icon(Icons.exit_to_app),
										onPressed: () {
											setState(() {
												globals.accessToken = null;
												globals.refreshToken = null;
												globals.username = null;
												globals.createdAt = null;
												globals.expiresIn = null;
												globals.me = null;
												if (_currentIndex == 2)
													_currentIndex = 0;
											});
										},
									)
								] : [],
							),
						)
					];
				},
				body: Builder(
					builder: (BuildContext context) {
						return SafeArea(

							left: false,
							top: _boxIsScrolled,
							bottom: false,
							right: false,
							child: _children[_currentIndex]
						);
					}
				)
			),
			floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
			floatingActionButton: (globals.accessToken != null) ? FloatingActionButton(
				onPressed: () {
					Navigator.push(context, MaterialPageRoute(builder: (context) {
						return PostPage();
					}));
				},
				backgroundColor: Color.fromRGBO(35, 35, 35, 1.0),
				child: Icon(Icons.add, color: Colors.white),
				elevation: 2.0,
				tooltip: "Upload",
			) : FloatingActionButton(
				onPressed: () {
					Navigator.push(context, MaterialPageRoute(builder: (context) {
						return Auth();
					}));
				},
				backgroundColor: Color.fromRGBO(35, 35, 35, 1.0),
				child: Icon(Icons.account_circle, color: Colors.white),
				elevation: 2.0,
				tooltip: "Authentication",
			),
			bottomNavigationBar: Theme(
				data: Theme.of(context).copyWith(
					canvasColor: Color.fromRGBO(16, 16, 16, 1.0)
				),
				child: BottomNavigationBar(
					onTap: onTabTapped,
					type: BottomNavigationBarType.shifting,
					currentIndex: _currentIndex, // this will be set when a new tab is tapped
					items: [
						BottomNavigationBarItem(
							backgroundColor: Color.fromRGBO(16, 16, 16, 1.0),
							icon: new Icon(Icons.home, color: (_currentIndex != 0) ? Color.fromRGBO(75, 75, 75, 1.0) : Colors.white),
							title: new Text('Home', style: TextStyle(color: Colors.white)),
						),
						BottomNavigationBarItem(
							backgroundColor: Color.fromRGBO(16, 16, 16, 1.0),
							icon: new Icon(Icons.search, color: (_currentIndex != 1) ? Color.fromRGBO(75, 75, 75, 1.0) : Colors.white),
							title: new Text('Search', style: TextStyle(color: Colors.white)),
						),
						BottomNavigationBarItem(
							backgroundColor: Color.fromRGBO(16, 16, 16, 1.0),
							icon: Icon(Icons.account_box, color: (_currentIndex != 2) ? Color.fromRGBO(75, 75, 75, 1.0) : Colors.white),
							title: Text("Profile", style: TextStyle(color: Colors.white)),
						)
					],
				),
			)
		);
	}

	@override
	void initState() {
		super.initState();
		_scroll = ScrollController();

		_scroll.addListener(() {
			var tmp = this._scroll.position.pixels > 20;
			if (tmp != this._boxIsScrolled) {
				setState(() {
					this._boxIsScrolled = tmp;
				});
			}
		});
	}

	@override
	void dispose() {
		_scroll.dispose();
		super.dispose();
	}
}

class HomePage extends StatefulWidget {

	@override
	HomePageState createState() => new HomePageState();
}