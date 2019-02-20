import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetSocketAddress;
import java.net.SocketException;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSlider;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

public class updClientMotorSelection extends JFrame{
	
	boolean spaceHeld = false;

	public updClientMotorSelection() {
		
		setLocationRelativeTo(null);
		
		JSlider freq = new JSlider(5, 1000, 1000);
		JLabel freqText = new JLabel(freq.getValue() + "");
		JSlider duty = new JSlider(0, 1023, 512);
		JLabel dutyText = new JLabel(duty.getValue() + "");
		
		freq.addChangeListener(new ChangeListener() {
			@Override
			public void stateChanged(ChangeEvent e) {
				freqText.setText(freq.getValue() + "");
			}
		});
		
		duty.addChangeListener(new ChangeListener() {
			@Override
			public void stateChanged(ChangeEvent e) {
				dutyText.setText(duty.getValue() + "");
			}
		});
		
		JPanel top = new JPanel();
		JPanel bottom = new JPanel();
		
		top.add(new JLabel("Frequency: "), BorderLayout.WEST);
		top.add(freq, BorderLayout.CENTER);
		top.add(freqText, BorderLayout.EAST);
		
		bottom.add(new JLabel("Duty Cycle: "), BorderLayout.WEST);
		bottom.add(duty, BorderLayout.CENTER);
		bottom.add(dutyText, BorderLayout.EAST);
		
		add(top, BorderLayout.NORTH);
		add(bottom, BorderLayout.SOUTH);
		
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
				
				byte[] buf = new byte[9];
				
				while (true) {
					try {
						buf = (freq.getValue() + "," + duty.getValue()).getBytes();
						esp.send(new DatagramPacket(buf, buf.length, new InetSocketAddress("192.168.4.1", 1336)));
					} catch (IOException e) {
						e.printStackTrace();
					}
					
					try {
						Thread.sleep(100);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			}
			
		}).start();
	}
	
	public static void main(String[] args) {
		JFrame frame = new updClientMotorSelection();
		frame.setDefaultCloseOperation(EXIT_ON_CLOSE);
		frame.setSize(new Dimension(400, 100));
		frame.setVisible(true);
	}

}
