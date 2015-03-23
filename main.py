import wx
import subprocess
import os
import re

def find_between( s, first, last ):
    try:
        start = s.index( first ) + len( first )
        end = s.index( last, start )
        return s[start:end]
    except ValueError:
        return ""

class ExamplePanel(wx.Panel):
    def __init__(self, parent):

        #constants
        self.precision = 2
        self.schemeA = ""
        self.schemeB = ""

        wx.Panel.__init__(self, parent)
        self.arithmetic = wx.StaticText(self, label="Arithmetic module comparator", pos=(20, 30))

        # A multiline TextCtrl - This is here to show how the events work in this program, don't pay too much attention to it
        self.arithmetic = wx.StaticText(self, label="Area cost of Scheme A", pos=(300, 30))
        self.areaA = wx.TextCtrl(self, pos=(300,60), size=(300,200), style=wx.TE_MULTILINE | wx.TE_READONLY)

        self.arithmetic = wx.StaticText(self, label="Area cost of Scheme B", pos=(650, 30))
        self.areaB = wx.TextCtrl(self, pos=(650,60), size=(300,200), style=wx.TE_MULTILINE | wx.TE_READONLY)

        # A button
        self.button =wx.Button(self, label="Compare", pos=(20, 250))
        self.Bind(wx.EVT_BUTTON, self.OnClick,self.button)

        # the edit control - one line version.
        self.lblname = wx.StaticText(self, label="Precision", pos=(20,60))
        self.editname = wx.TextCtrl(self, value="", pos=(150, 60), size=(140,-1))
        self.Bind(wx.EVT_TEXT, self.EvtText, self.editname)

        # the combobox Control
        self.sampleList = ['CCA', 'CSA','CLA','CRA','LING','MCC','KSA','BKA']
        self.lblhear = wx.StaticText(self, label="Choose your first module", pos=(20, 90))
        self.edithear = wx.ComboBox(self, pos=(20, 110), size=(95, -1), choices=self.sampleList, style=wx.CB_DROPDOWN)
        self.Bind(wx.EVT_COMBOBOX, self.EvtComboBox, self.edithear)
        self.Bind(wx.EVT_TEXT, self.EvtText,self.edithear)

        #second combobox
	self.lblhear = wx.StaticText(self, label="Choose your second module", pos=(20, 150))
        self.edithear2 = wx.ComboBox(self, pos=(20, 170), size=(95, -1), choices=self.sampleList, style=wx.CB_DROPDOWN)
        self.Bind(wx.EVT_COMBOBOX, self.EvtComboBox2, self.edithear2)
        self.Bind(wx.EVT_TEXT, self.EvtText,self.edithear2)


    def OnClick(self,event):
	print "Adding precision to verilog file"	
	defpre = "`define WIDTH " + self.precision
	vfile1 = self.schemeA + '.v'
	vfile2 = self.schemeB + '.v'
	
	f_temp1 = open(vfile1, 'r')
	content1 = f_temp1.read()
	f_temp1.close()
	
	f_temp1 = open(vfile1, 'w')
      	f_temp1.write(defpre.rstrip('\r\n') + '\n' + content1)
	f_temp1.close()
	
	f_temp2 = open(vfile2, 'r')
	content2 = f_temp2.read() 
	
	
	f_temp2 = open(vfile2, 'w')
        f_temp2.write(defpre.rstrip('\r\n') + '\n' + content2)
	f_temp2.close()
	
	print "Begin synthesis process"	
	#For scheme A
        command = "./run_" + self.schemeA + '.sh | ./run_' + self.schemeB + '.sh'
	os.system(command)
        print "Synthesis finished, analyzing synthesis report"

        f2open1 = "design_" + self.schemeA + ".srp"
	f1 = open(f2open1, 'r')
	area_costA = "Area for scheme A with precision " + self.precision + "\n====================\n" + find_between( f1.read(), "\nMacro Statistics\n", "\n\n===========" ) + '\n'
	self.areaA.AppendText(area_costA)
	
	f1.close()
	#for scheme B
        f2open2 = "design_" + self.schemeB + ".srp"
        f2 = open(f2open2, 'r')
        area_costB = "Area for scheme B with precision " + self.precision + "\n====================\n"+find_between( f2.read(), "\nMacro Statistics\n", "\n\n===========" ) + '\n'
        self.areaB.AppendText(area_costB)
	#delay2 = int(find_between(f2.read(),"Maximum combinational path delay: ", "ns\n\nTiming Details:"))
	f2.close()

	f1 = open(f2open1, 'r')
	delay1 = find_between(f1.read(),"Maximum combinational path delay: ", "ns\n")
	f1.close()

	f2 = open(f2open2, 'r')
	delay2 = find_between(f2.read(),"Maximum combinational path delay: ", "ns\n")
	f2.close()

	print "plotting delay chart"
	print "delay 1: " +delay1 + " delay2: "+ delay2
	plotcommand = "python simple_plot.py " + delay1 +" "+ delay2+" " + self.schemeA+" "+self.schemeB
	os.system(plotcommand)
	png = wx.Image('foo.png', wx.BITMAP_TYPE_ANY).Rescale(300,300).ConvertToBitmap()
	wx.StaticBitmap(self, -1, png, (300, 300), (300, 300))	

	f_temp1 = open(vfile1, 'w')
      	f_temp1.write(content1)
	f_temp1.close()
	
	f_temp2 = open(vfile2, 'w')
        f_temp2.write(content2)
	f_temp2.close()

	pwr1 = self.schemeA + ".pwr"
	fx1 = open(pwr1, 'r')
	pwA = find_between(fx1.read(),"| Supply Power (mW)    | ", " | ")
	fx1.close()


	pwr2 = self.schemeB + ".pwr"
	fx2 = open(pwr2, 'r')
	pwB = find_between(fx2.read(),"| Supply Power (mW)    | ", " | ")
	fx2.close()
	
	print "plotting power chart"
	plotcommandpw = "python simple_plot2.py " + pwA +" "+ pwB + " " + self.schemeA+" "+self.schemeB
	os.system(plotcommandpw)
	png = wx.Image('bar.png', wx.BITMAP_TYPE_ANY).Rescale(300,300).ConvertToBitmap()
	wx.StaticBitmap(self, -1, png, (650, 300), (300, 300))

	print "Cleaning up temp files"
	os.system("./cleanup.sh")
	
    def EvtComboBox(self, event):
        self.schemeA = self.edithear.GetValue()
    def EvtComboBox2(self, event):
        self.schemeB = self.edithear2.GetValue()
    def EvtText(self, event):
        pvalue = self.editname.GetValue()
        if pvalue == "":
                self.precision = "1"
        else:
                self.precision = pvalue


app = wx.App(False)
frame = wx.Frame(None)
panel = ExamplePanel(frame)
frame.Show()
app.MainLoop()
