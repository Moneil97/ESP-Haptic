import java.awt.Dimension;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetSocketAddress;
import java.net.SocketException;

import javax.swing.JFrame;

public class udpClientMotorToggle extends JFrame{
	
	boolean spaceHeld = false;

	public udpClientMotorToggle() {
		
		setLocationRelativeTo(null);
		addKeyListener(new KeyListener() {
			
			@Override
			public void keyTyped(KeyEvent e) {}
			
			@Override
			public void keyReleased(KeyEvent e) {
				if (e.getKeyCode() == KeyEvent.VK_SPACE) {
					spaceHeld = false;
				}
				else {
					System.out.println("released:" + e.getKeyCode());
				}
			}
			
			@Override
			public void keyPressed(KeyEvent e) {
				if (e.getKeyCode() == KeyEvent.VK_SPACE) {
					spaceHeld = true;
				}
				else {
					System.out.println("holding:" + e.getKeyCode());
				}
			}
		});
		
		
		new Thread(new Runnable() {
			
			@SuppressWarnings("resource")
			@Override
			public void run() {
				DatagramSocket esp = null;
				while (esp == null) {
					try {
						esp = new DatagramSocket();
					} catch (SocketException e) {
						e.printStackTrace();
						try {
							Thread.sleep(1000);
						} catch (InterruptedException ee) {
							ee.printStackTrace();
						}
					}
				}
				
				byte[] buf = new byte[1];
				buf[0] = '1';
				
				
				String MAC = "55-55-55-55-55-55";
				String IP = MACmapper.mapMACtoIP(MAC);
				System.out.println(IP);
				
				
				while (true) {
					try {
						if (spaceHeld)
							esp.send(new DatagramPacket(buf, 1, new InetSocketAddress(IP, 60000)));
					} catch (IOException e) {
						e.printStackTrace();
					}
					
					try {
						Thread.sleep(50);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			}
			
		}).start();
		
		
	}
	
	public static void main(String[] args) {
		JFrame frame = new udpClientMotorToggle();
		frame.setDefaultCloseOperation(EXIT_ON_CLOSE);
		frame.setSize(new Dimension(200, 100));
		frame.setVisible(true);
	}

}
