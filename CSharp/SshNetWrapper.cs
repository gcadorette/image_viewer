using Godot;
using Renci.SshNet;
using System;

public partial class SshNetWrapper : Node
{
    private string hostname;
    private int port;
    private string username;
    private string password;

    public SshNetWrapper(string hostname, int port, string username, string password) {
        this.hostname = hostname;
        this.port = port;
        this.username = username;
        this.password = password;
    }

    public string TestConnection() {
        try {
            using var scpClient = new ScpClient(this.hostname, this.port, this.username, this.password);
            scpClient.Connect();
            return "";
        } catch (Exception ex) {
            return ex.ToString();
        }
    }
}
