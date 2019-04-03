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
	
	var contentLabel: UITextView?
	var timeLabel: UILabel?
	var bubbleImage: UIImageView?
	var statusIcon: UIImageView?
	
	public static func create(_ message: PFObject!) -> ChatSingleMessageCell {
		let cellIdentifier = "ChatSingleMessageCell"
		let cell = ChatSingleMessageCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
		cell.setMessage(message)
		return cell
	}
	
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
		
		self.contentLabel = UITextView()
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
		let view_width = self.contentView.frame.width as CGFloat
		
		//Single Line Case
		return (textView_height <= 45 && (textView_width + delta_x) <= 0.8 * view_width) ? true : false
	}
	
	func setTextLabel() {
		let max_width = (self.contentView.frame.width * 0.7) as CGFloat
		self.contentLabel!.frame = CGRect(x: CGFloat(0),
										  y: CGFloat(0),
										  width: max_width,
										  height: CGFloat(FLT_MAX))
		self.contentLabel!.font = UIFont(name: "Helvetica", size: 17.0)
		self.contentLabel!.backgroundColor = UIColor.clear
		self.contentLabel!.isUserInteractionEnabled = false
		
		self.contentLabel!.text = self.message?["content"] as? String;
		self.contentLabel!.sizeToFit()
		
		var orgX: CGFloat
		var orgY: CGFloat = 0
		let width = self.contentLabel!.frame.size.width
		let height = self.contentLabel!.frame.size.height
		var autoresizing: UIView.AutoresizingMask
		
		if (MessageManager.fromMe(self.message)) {
			orgX = self.contentView.frame.width - width - 20
			autoresizing = UIView.AutoresizingMask.flexibleLeftMargin
			orgX = orgX - (self.isSingleLineCase() ? 65.0 : 0.0)
//			textView_x -= [self isStatusFailedCase]?([self fail_delta]-15):0.0;
		}
		else
		{
			orgX = 20
			autoresizing = UIView.AutoresizingMask.flexibleRightMargin
		}
		
		self.contentLabel!.frame = CGRect(x: orgX,
										  y: orgY,
										  width: width,
										  height: height)
		self.contentLabel!.autoresizingMask = autoresizing;
	}
	
	func setTimeLabel() {
		self.timeLabel!.frame = CGRect(x: 0, y: 0, width: 52, height: 14)
		self.timeLabel!.textColor = UIColor.lightGray
		self.timeLabel!.font = UIFont(name: "Helvetica", size: 12.0)
		self.timeLabel!.isUserInteractionEnabled = false
		self.timeLabel!.alpha = 0.7
		self.timeLabel!.textAlignment = NSTextAlignment.right
		
		//Set Text to Label
		let updatedAt = self.message?.updatedAt
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		self.timeLabel!.text = dateFormatter.string(from: updatedAt!)
		
		//Set position
		var orgX: CGFloat!
		var orgY = self.contentLabel!.frame.origin.y + self.contentLabel!.frame.size.height
		
		if (MessageManager.fromMe(self.message))
		{
			orgX = self.contentLabel!.frame.origin.x + self.contentLabel!.frame.size.width - self.timeLabel!.frame.size.width - 20
		}
		else
		{
			orgX = max(self.contentLabel!.frame.origin.x + self.contentLabel!.frame.size.width - self.timeLabel!.frame.size.width,
						 self.contentLabel!.frame.origin.x)
		}
		
		if self.isSingleLineCase() {
			orgX = self.contentLabel!.frame.origin.x + self.contentLabel!.frame.size.width - 5
//			orgY -= 10
		}
		
		self.timeLabel!.frame = CGRect(x: orgX,
									  y: orgY,
									  width: self.timeLabel!.frame.size.width,
									  height: self.timeLabel!.frame.size.height)
		self.timeLabel!.autoresizingMask = self.contentLabel!.autoresizingMask;
	}
	
	func setBubble() {
		//Margins to Bubble
		let marginLeft = 5 as CGFloat
		let marginRight = 2 as CGFloat
		
		//Bubble positions
		var orgX: CGFloat
		let orgY = 0 as CGFloat
		let width: CGFloat
		let height = self.contentLabel!.frame.size.height + self.timeLabel!.frame.size.height + 8
		
		if (MessageManager.fromMe(self.message)) {
			orgX = min(self.contentLabel!.frame.origin.x - marginLeft,
						   self.contentLabel!.frame.origin.x - 2 * marginLeft)
			
			self.bubbleImage?.image = UIImage(named:"bubbleMine")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 14)
			
			width = self.contentView.frame.width - orgX - marginRight
		} else {
			orgX = marginRight
			self.bubbleImage?.image = UIImage(named: "bubbleSomeone")?.stretchableImage(withLeftCapWidth: 21, topCapHeight: 14)
			
			let contentWidth = self.contentLabel!.frame.origin.x + self.contentLabel!.frame.size.width + marginLeft
			let timeWidth = self.timeLabel!.frame.origin.x + self.timeLabel!.frame.size.width + 2 * marginLeft
			width = max(contentWidth, timeWidth)
		}
		
		self.bubbleImage?.frame = CGRect(x: orgX,
										 y: orgY,
										 width: width,
										 height: height)
		self.bubbleImage!.autoresizingMask = self.contentLabel!.autoresizingMask
	}
}
