//
//  Channel.swift
//  Sword
//
//  Created by Alejandro Alonso
//  Copyright © 2017 Alejandro Alonso. All rights reserved.
//

import Foundation

/// Generic Channel structure
public protocol Channel {

  // MARK: Properties

  /// Parent class
  weak var sword: Sword? { get }

  /// The id of the channel
  var id: ChannelID { get }

  /// The last message's id
  var lastMessageId: MessageID? { get }
  
  /// Indicates what type of channel this is
  var type: ChannelType { get }

}

public extension Channel {

  // MARK: Functions

  /**
   Adds a reaction (unicode or custom emoji) to message

   - parameter reaction: Unicode or custom emoji reaction
   - parameter messageId: Message to add reaction to
  */
  public func addReaction(_ reaction: String, to messageId: MessageID, then completion: @escaping (RequestError?) -> () = {_ in}) {
    guard self.type != .guildVoice else { return }
    self.sword?.addReaction(reaction, to: messageId, in: self.id, then: completion)
  }

  /// Deletes the current channel, whether it be a DMChannel or GuildChannel
  public func delete(then completion: @escaping (Channel?, RequestError?) -> () = {_ in}) {
    self.sword?.deleteChannel(self.id, then: completion)
  }

  /**
   Deletes a message from this channel

   - parameter messageId: Message to delete
  */
  public func deleteMessage(_ messageId: MessageID, then completion: @escaping (RequestError?) -> () = {_ in}) {
    guard self.type != .guildVoice else { return }
    self.sword?.deleteMessage(messageId, from: self.id, then: completion)
  }

  /**
   Bulk deletes messages

   - parameter messages: Array of message ids to delete
  */
  public func deleteMessages(_ messages: [MessageID], then completion: @escaping (RequestError?) -> () = {_ in}) {
    guard self.type != .guildVoice else { return }
    self.sword?.deleteMessages(messages, from: self.id, then: completion)
  }

  /**
   Deletes a reaction from message by user

   - parameter reaction: Unicode or custom emoji to delete
   - parameter messageId: Message to delete reaction from
   - parameter userId: If nil, deletes bot's reaction from, else delete a reaction from user
  */
  public func deleteReaction(_ reaction: String, from messageId: MessageID, by userId: UserID? = nil, then completion: @escaping (RequestError?) -> () = {_ in}) {
    guard self.type != .guildVoice else { return }
    self.sword?.deleteReaction(reaction, from: messageId, by: userId, in: self.id, then: completion)
  }

  /**
   Edits a message's content

   - parameter messageId: Message to edit
   - parameter content: Text to change message to
  */
  public func editMessage(_ messageId: MessageID, with options: [String: Any], then completion: @escaping (Message?, RequestError?) -> () = {_ in}) {
    guard self.type != .guildVoice else { return }
    self.sword?.editMessage(messageId, with: options, in: self.id, then: completion)
  }

  /**
   Gets a message from this channel

   - parameter messageId: Id of message you want to get
  **/
  public func getMessage(_ messageId: MessageID, then completion: @escaping (Message?, RequestError?) -> ()) {
    guard self.type != .guildVoice else { return }
    self.sword?.getMessage(messageId, from: self.id, then: completion)
  }

  /**
   Gets an array of messages from this channel

   #### Option Params ####

   - **around**: Message Id to get messages around
   - **before**: Message Id to get messages before this one
   - **after**: Message Id to get messages after this one
   - **limit**: Number of how many messages you want to get (1-100)

   - parameter options: Dictionary containing optional options regarding how many messages, or when to get them
  **/
  public func getMessages(with options: [String: Any]? = nil, then completion: @escaping ([Message]?, RequestError?) -> ()) {
    guard self.type != .guildVoice else { return }
    self.sword?.getMessages(from: self.id, with: options, then: completion)
  }

  /**
   Gets an array of users who used reaction from message

   - parameter reaction: Unicode or custom emoji to get
   - parameter messageId: Message to get reaction users from
  */
  public func getReaction(_ reaction: String, from messageId: MessageID, then completion: @escaping ([User]?, RequestError?) -> ()) {
    guard self.type != .guildVoice else { return }
    self.sword?.getReaction(reaction, from: messageId, in: self.id, then: completion)
  }

  /// Get Pinned messages for this channel
  public func getPinnedMessages(then completion: @escaping ([Message]?, RequestError?) -> () = {_ in}) {
    guard self.type != .guildVoice else { return }
    self.sword?.getPinnedMessages(from: self.id, then: completion)
  }

  /**
   Pins a message to this channel

   - parameter messageId: Message to pin
  */
  public func pin(_ messageId: MessageID, then completion: @escaping (RequestError?) -> () = {_ in}) {
    guard self.type != .guildVoice else { return }
    self.sword?.pin(messageId, in: self.id, then: completion)
  }

  /**
   Sends a message to channel

   - parameter message: Message to send
  */
  public func send(_ message: Any, then completion: @escaping (Message?, RequestError?) -> () = {_ in}) {
    guard self.type != .guildVoice else { return }
    self.sword?.send(message, to: self.id, then: completion)
  }

  /**
   Unpins a pinned message from this channel

   - parameter messageId: Pinned message to unpin
  */
  public func unpin(_ messageId: MessageID, then completion: @escaping (RequestError?) -> () = {_ in}) {
    guard self.type != .guildVoice else { return }
    self.sword?.unpin(messageId, from: self.id, then: completion)
  }

}

/// Used to indicate the type of channel
public enum ChannelType: Int {
  
  /// This is a regular Guild Text Channel (`GuildChannel`)
  case guildText
  
  /// This is a 1 on 1 DM with a user (`DMChannel`)
  case dm
  
  /// This is the famous Guild Voice Channel (`GuildChannel`)
  case guildVoice
  
  /// This is a Group DM Channel (`GroupChannel`)
  case groupDM
  
  /// This is an unreleased Guild Category Channel
  case guildCategory
}
