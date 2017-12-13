import java.awt.datatransfer.Clipboard;
import java.awt.Toolkit;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;


void writeTextToClipboard(String s) {
  Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
  Transferable t = new StringSelection(s);
  clipboard.setContents(t, null);
}

String GetTextFromClipboard(){
  String text = (String) GetFromClipboard(DataFlavor.stringFlavor);
  return text;
}

Object GetFromClipboard(DataFlavor flavor){
  Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
  Transferable contents = clipboard.getContents(null);
  Object obj = null;
  if (contents != null && contents.isDataFlavorSupported(flavor)){
    try{
      obj = contents.getTransferData(flavor);
    }
    catch (UnsupportedFlavorException exu){ // Unlikely but we must catch it
      println("Unsupported flavor: " + exu);
    }
    catch (java.io.IOException exi){
      println("Unavailable data: " + exi);
    }
  }
  return obj;
}