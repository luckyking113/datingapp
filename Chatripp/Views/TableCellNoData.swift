//
//  TableCellNoData
//  Chatripp
//
//  Created by Famousming on 2019/02/26.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import UIKit

class TableCellNoData: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
