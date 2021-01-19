import 'package:flutter/material.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:realtime_chat/models/usuario.dart';
import 'package:realtime_chat/widgets/usuario_list_tile.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  // RefreshController _refreshController =
  // RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uuid: '1', nombre: 'María', email: 'test1@test.com', online: true),
    Usuario(
        uuid: '2', nombre: 'Demetrio', email: 'test2@test.com', online: true),
    Usuario(uuid: '3', nombre: 'Sara', email: 'test3@test.com', online: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Nombre',
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black54,
          ),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle,
                color: Colors
                    .blue[400]), // Icon(Icons.offline_bolt, color: Colors.red)
          ),
        ],
      ),
      body: _listViewUsuarios(),
      // SmartRefresher(
      // controller: _refreshController,
      // enablePullDown: true,
      // header: WaterDropHeader(
      // complete: Icon(Icons.check, color: Colors.blue[400]),
      // waterDropColor: Colors.blue[400],
      // ),
      // child: _listViewUsuarios(),
      // ),

      floatingActionButton: FloatingActionButton(
        onPressed: _cargarUsuarios,
        child: Icon(Icons.refresh_outlined),
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => UsuarioListTile(usuario: usuarios[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: usuarios.length,
    );
  }

  _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    //_refreshController.refreshCompleted();
  }
}
