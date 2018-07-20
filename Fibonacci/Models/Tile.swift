//
//  Tile.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import SpriteKit

typealias Block = () -> Void

class Tile: SKShapeNode {
    /** The level of the tile. */
    var level: Int = 0
    
    /** The cell this tile belongs to. */
    weak var cell: M2Cell?
    
    /** The value of the tile, as some text. */
    private var value: SKLabelNode?
    
    /** Pending actions for the tile to execute. */
    private var pendingActions: [AnyHashable] = []
    
    /** Pending function to call after @p _pendingActions are executed. */
    private var pendingBlock: M2Block?
    
    init() {
        super.init()
        
        // Layout of the tile.
        let rect = CGRect(x: 0, y: 0, width: CGFloat(GSTATE.tileSize()), height: CGFloat(GSTATE.tileSize()))
        let rectPath = CGPathCreateWithRoundedRect(rect, GSTATE.cornerRadius, GSTATE.cornerRadius, nil)
        path = rectPath
        lineWidth = 0
        
        // Initiate pending actions queue.
        pendingActions = [AnyHashable]()
        
        // Set up value label.
        value = SKLabelNode(fontNamed: GSTATE.boldFontName())
        value.position = CGPoint(x: Int(GSTATE.tileSize()) / 2, y: Int(GSTATE.tileSize()) / 2)
        value.horizontalAlignmentMode = .center
        value.verticalAlignmentMode = .center
        addChild(value)
        
        // For Fibonacci game, which is way harder than 2048 IMO, 40 seems to be the easiest number.
        // 90 definitely won't work, as we need approximately equal number of 2 and 3 to make the
        // game remotely makes sense.
        if GSTATE.gameType == M2GameTypeFibonacci {
            level = arc4random_uniform(100) < 40 ? 1 : 2
        } else {
            level = arc4random_uniform(100) < 95 ? 1 : 2
        }
        
        refreshValue()
    }
    
    // MARK: - Tile creation
    
    /**
     * Creates and inserts a new tile at the specified cell.
     *
     * @param cell The cell to insert tile into.
     * @return The tile created.
     */
    class func insertNewTile(to cell: M2Cell?) -> M2Tile? {
        let tile = M2Tile()
        // The initial position of the tile is at the center of its cell. This is so because when
        // scaling the tile, SpriteKit does so from the origin, not the center. So we have to scale
        // the tile while moving it back to its normal position to achieve the "pop out" effect.
        let origin: CGPoint = GSTATE.locationOfPosition(cell?.position)
        tile.position = CGPoint(x: origin.x + Int(GSTATE.tileSize()) / 2, y: origin.y + Int(GSTATE.tileSize()) / 2)
        tile.setScale(0)
        cell?.tile = tile
        return tile
    }
    
    // MARK: - Public methods
    
    func removeFromParentCell() {
        // Check if the tile is still registered with its parent cell, and if so, remove it.
        // We don't really care about self.cell, because that is a weak pointer.
        if cell.tile == self {
            cell.tile = nil
        }
    }
    
    func hasPendingMerge() -> Bool {
        // A move is only one action, so if there are more than one actions, there must be
        // a merge that needs to be committed. If things become more complicated, change
        // this to an explicit ivar or property.
        return pendingActions.count > 1
    }
    
    func commitPendingActions() {
        run(SKAction.sequence(pendingActions)) {
            pendingActions.removeAll()
            if pendingBlock {
                pendingBlock()
                pendingBlock = nil
            }
        }
    }
    
    /**
     * Whether this tile can merge with the given tile.
     *
     * @param tile The target tile to merge with.
     * @return YES if the two tiles can be merged.
     */
    func canMerge(with tile: M2Tile?) -> Bool {
        if tile == nil {
            return false
        }
        return GSTATE.isLevel(level, mergeableWithLevel: tile?.level)
    }
    
    /**
     * Checks whether this tile can merge with the given tile, and merge them
     * if possible. The resulting tile is at the position of the given tile.
     *
     * @param tile Target tile to merge into.
     * @return The resulting level of the merge, or 0 if unmergeable.
     */
    func merge(to tile: M2Tile?) -> Int {
        // Cannot merge with thin air. Also cannot merge with tile that has a pending merge.
        // For the latter, imagine we have 4, 2, 2. If we move to the right, it will first
        // become 4, 4. Now we cannot merge the two 4's.
        if tile == nil || tile?.hasPendingMerge() != nil {
            return 0
        }
        
        let newLevel = GSTATE.mergeLevel(level, withLevel: tile?.level)
        
        if newLevel > 0 {
            // 1. Move self to the destination cell.
            move(toCell: tile?.cell)
            // 2. Remove the tile in the destination cell.
            tile?.removeWithDelay()
            // 3. Update value and pop.
            updateLevel(to: newLevel)
            pendingActions.append(pop())
        }
        
        return newLevel
    }
    
    func merge3(to tile: M2Tile?, andTile furtherTile: M2Tile?) -> Int {
        if tile == nil || tile?.hasPendingMerge() != nil || furtherTile?.hasPendingMerge() != nil {
            return 0
        }
        
        let newLevel = min(GSTATE.mergeLevel(level, withLevel: tile?.level), GSTATE.mergeLevel(tile?.level, withLevel: furtherTile?.level))
        
        if newLevel > 0 {
            // 1. Move self to the destination cell AND move the intermediate tile to there too.
            tile?.move(toCell: furtherTile?.cell)
            move(toCell: furtherTile?.cell)
            // 2. Remove the tile in the destination cell.
            tile?.removeWithDelay()
            furtherTile?.removeWithDelay()
            // 3. Update value and pop.
            updateLevel(to: newLevel)
            pendingActions.append(pop())
        }
        
        return newLevel
    }
    
    func updateLevel(to level: Int) {
        self.level = level
        pendingActions.append(SKAction.run({
            self.refreshValue()
        }))
    }
    
    func refreshValue() {
        let value = GSTATE.value(forLevel: level)
        self.value.text = "\(value)"
        self.value.fontColor = GSTATE.textColor(forLevel: level)
        self.value.fontSize = GSTATE.textSize(forValue: value)
        fillColor = GSTATE.color(forLevel: level)
    }
    
    /**
     * Moves the tile to the specified cell. If the tile is not already in the grid,
     * calling this method would result in error.
     *
     * @param cell The destination cell.
     */
    func move(to cell: M2Cell?) {
        pendingActions.append(SKAction.move(to: GSTATE.locationOfPosition(cell?.position), duration: TimeInterval(GSTATE.animationDuration())))
        self.cell.tile = nil
        cell?.tile = self
    }
    
    /**
     * Removes the tile from its cell and from the scene.
     *
     * @param animated If YES, the removal will be animated.
     */
    func remove(animated: Bool) {
        if animated {
            pendingActions.append(SKAction.scale(to: 0, duration: TimeInterval(GSTATE.animationDuration())))
        }
        
        pendingActions.append(SKAction.removeFromParent())
        
        weak var weakSelf: M2Tile? = self
        
        pendingBlock = {
            weakSelf?.removeFromParentCell()
        }
        
        commitPendingActions()
    }
    
    func removeWithDelay() {
        let wait = SKAction.wait(forDuration: TimeInterval(GSTATE.animationDuration()))
        let remove = SKAction.removeFromParent()
        
        run(SKAction.sequence([wait, remove])) {
            self.removeFromParentCell()
        }
    }
    
    // MARK: - SKAction helpers
    
    func pop() -> SKAction? {
        let d: CGFloat = 0.15 * Double(GSTATE.tileSize())
        let wait = SKAction.wait(forDuration: TimeInterval(GSTATE.animationDuration() / 3))
        let enlarge = SKAction.scale(to: 1.3, duration: GSTATE.animationDuration() / 1.5)
        let move = SKAction.move(by: CGVectorMake(-d, -d), duration: GSTATE.animationDuration() / 1.5)
        let restore = SKAction.scale(to: 1, duration: GSTATE.animationDuration() / 1.5)
        let moveBack = SKAction.move(by: CGVectorMake(d, d), duration: GSTATE.animationDuration() / 1.5)
        
        return SKAction.sequence([wait, SKAction.group([enlarge, move]), SKAction.group([restore, moveBack])])
    }
}
