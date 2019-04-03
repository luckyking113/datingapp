//
//  ChatHomeTableViewCell.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/31.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit
import Parse

class ChatSingleMessageCell: UITableViewCell {
	
	var message: PFObject?
	
	var contentLabel: UITextField?
	var timeLabel: UILabel?
	var bubbleImage: UIImageView?
	var statusIcon: UIImageView?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.commonInit()
	}
	
	required init(coder decoder: NSCoder) {
		super.init(coder: decoder)!
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		self.commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		self.contentLabel!.text = ""
		self.timeLabel!.text = ""
		self.statusIcon!.image = nil
	}
	
	public func height() -> CGFloat {
		return self.bubbleImage!.frame.size.height
	}
	
	func commonInit() {
		self.backgroundColor = UIColor.clear;
		self.contentView.backgroundColor = UIColor.clear;
		self.selectionStyle = UITableViewCell.SelectionStyle.none;
		self.accessoryType = UITableViewCell.AccessoryType.none;
		
		self.contentLabel = UITextField()
		self.bubbleImage = UIImageView()
		self.timeLabel = UILabel()
		self.statusIcon = UIImageView()
		
		self.contentView.addSubview(self.bubbleImage!)
		self.contentView.addSubview(self.contentLabel!)
		self.contentView.addSubview(self.timeLabel!)
		self.contentView.addSubview(self.statusIcon!)
	}

	public func setMessage(_ message:PFObject!) {
		self.message = message
		
		self.setTextLabel()
		self.setTimeLabel();
		self.setBubble();
		
		self.setNeedsLayout()
	}
	
	private func isSingleLineCase() -> Bool {
		let delta_x = (MessageManager.fromMe(self.message) ? 65.0 : 44.0) as CGFloat
		
		let textView_height = self.contentLabel!.frame.size.height as CGFloat
		let textView_width = self.contentLabel!.frame.size.width as CGFloat
		let view_width = UIScreen.main.bounds.width as CGFloat
		
		//Single Line Case
		return (textView_height <= 45 && (textView_width + delta_x) <= 0.8 * view_width) ? true : false
	}
	
	func setTextLabel() {
		let max_width = UIScreen.main.bounds.width * 0.7
		self.contentLabel!.frame = CGRect(x: .zero, y: .zero, width: max_width, height: 999)
		self.contentLabel!.font = UIFont(name: "Helvetica", size: 17.0)
		self.contentLabel!.backgroundColor = UIColor.clear
		self.contentLabel!.isUserInteractionEnabled = false
		
		self.contentLabel!.text = self.message?["content"] as? String;
		self.contentLabel!.sizeToFit()
		
		var textView_x: CGFloat
		var textView_y: CGFloat
		let textView_w = self.contentLabel!.frame.size.width
		let textView_h = self.contentLabel!.frame.size.height
		var autoresizing: UIView.AutoresizingMask
		
		if (MessageManager.fromMe(self.message))
		{
			textView_x = UIScreen.main.bounds.width - textView_w - 20
			textView_y = -3
			autoresizing = UIView.AutoresizingMask.flexibleLeftMargin
			textView_x = textView_x - (self.isSingleLineCase() ? 65.0 : 0.0)
//			textView_x -= [self isStatusFailedCase]?([self fail_delta]-15):0.0;
		}
		else
		{
			textView_x = 20
			textView_y = -1
			autoresizing = UIView.AutoresizingMask.flexibleRightMargin
		}
		
		self.contentLabel!.autoresizingMask = autoresizing;
		self.contentLabel!.frame = CGRect(x: textView_x, y: textView_y, width: textView_w, height: textView_h)
	}
	
	func setTimeLabel() {
		self.timeLabel!.frame = CGRect(x: 0, y: 0, width: 52, height: 14)
		self.timeLabel!.textColor = UIColor.lightGray
		self.timeLabel!.font = UIFont(name: "Helvetica", size: 12.0)
		self.timeLabel!.isUserInteractionEnabled = false
		self.timeLabel!.alpha = 0.7
		self.timeLabel!.textAlignment = NSTextAlignment.right
		
		//Set position
		var time_x: CGFloat!
		var time_y = self.contentLabel!.frame.size.height - 10
		
		if (MessageManager.fromMe(self.message))
		{
			time_x = self.contentLabel!.frame.origin.x + self.contentLabel!.frame.size.width - self.timeLabel!.frame.size.width - 20
		}
		else
		{
			time_x = max(self.contentLabel!.frame.origin.x + self.contentLabel!.frame.size.width - self.timeLabel!.frame.size.width,
						 self.contentLabel!.frame.origin.x)
		}
		
		if self.isSingleLineCase() {
			time_x = self.contentLabel!.frame.origin.x + self.contentLabel!.frame.size.width - 5
			time_y -= 10
		}
		
		self.timeLabel!.frame = CGRect(x: time_x,
									  y: time_y,
									  width: self.timeLabel!.frame.size.width,
									  height: self.timeLabel!.frame.size.height)
		
		self.timeLabel!.autoresizingMask = self.contentLabel!.autoresizingMask;
	}
	
	func setBubble() {
		//Margins to Bubble
		let marginLeft = 5 as CGFloat
		let marginRight = 2 as CGFloat
		
		//Bubble positions
		var bubble_x: CGFloat
		let bubble_y = 0 as CGFloat
		let bubble_width: CGFloat
		let bubble_height = min(self.contentLabel!.frame.size.height + 8,
								self.contentLabel!.frame.origin.y + self.contentLabel!.frame.size.height + 6) as CGFloat
		
		if (MessageManager.fromMe(self.message)) {
			
			bubble_x = min(self.contentLabel!.frame.origin.x - marginLeft,
						   self.contentLabel!.frame.origin.x - 2 * marginLeft)
			
			self.bubbleImage?.image = UIImage(named:"bubbleMine")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
			
			bubble_width = UIScreen.main.bounds.width - bubble_x - marginRight
		}
		else
		{
			bubble_x = marginRight
			self.bubbleImage?.image = UIImage(named: "bubbleSomeone")?.stretchableImage(withLeftCapWidth: 21, topCapHeight: 14)
			
			let contentWidth = self.contentLabel!.frame.origin.x + self.contentLabel!.frame.size.width + marginLeft
			let timeWidth = self.timeLabel!.frame.origin.x + self.timeLabel!.frame.size.width + 2 * marginLeft
			bubble_width = max(contentWidth, timeWidth)
		}
		
		self.bubbleImage?.frame = CGRect(x: bubble_x, y: bubble_y, width: bubble_width, height: bubble_height)
		self.bubbleImage!.autoresizingMask = self.contentLabel!.autoresizingMask
	}
}
